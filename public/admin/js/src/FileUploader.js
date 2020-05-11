class FileUploader {
  constructor(editor) {
    this.editor = editor;
    this.observeDragAndDrop();
  };

  isAvailable() {
    const div = document.createElement('div');
    return (('draggable' in div) || ('ondragstart' in div && 'ondrop' in div)) && 'FormData' in window && 'FileReader' in window;
  };

  observeDragAndDrop() {
    const editor = this.editor;
    const self = this;

    if (editor.dataset.uploadObserved) {
      console.log("The editor is already observed by FileUploader");
      return;
    }

    if (!this.isAvailable()) {
      console.log("Drag and Drop upload is not available on this Browser");
      return false;
    }

    const eventsToIgnore       = ['drag', 'dragstart', 'dragend', 'dragover', 'dragenter', 'dragleave', 'drop'];
    const eventsToAddClass     = ['drag', 'dragstart', 'dragover', 'dragenter'];
    const eventsToRemoveClass  = ['dragleave', 'dragend', 'drop'];
    const eventsToHandleUpload = ['drop', 'paste'];

    eventsToIgnore.forEach(event => {
      editor.addEventListener(event, (e) => {
        e.preventDefault();
        e.stopPropagation();
      });
    });
    eventsToAddClass.forEach(event => {
      editor.addEventListener(event, (e) => {
        editor.classList.add('is-dragover');
      });
    });
    eventsToRemoveClass.forEach(event => {
      editor.addEventListener(event, (e) => {
        editor.classList.remove('is-dragover');
      });
    });
    eventsToHandleUpload.forEach(event => {
      editor.addEventListener(event, (e) => {
        let source, droppedItems;
        if (event === 'paste') {
          source = e.clipboardData;
        } else {
          source = e.dataTransfer;
        }
        if (!source.types.some(type => type === 'Files')) {
          return;
        }
        droppedItems = source.items;
        for (const item of droppedItems) {
          const file = item.getAsFile();
          if (file && /^image\//.test(file.type)) {
            self.upload(file);
          }
        }
        droppedItems = null;
        e.preventDefault();
      });
    });

    this.editor.dataset.uploadObserved = true;
  };

  upload(file) {
    const editor = this.editor;
    const textarea = editor.querySelector('textarea');
    const ajaxData = new FormData();
    const self = this;
    ajaxData.append('file', file);
    let promise = new Promise((resolve, reject) => {
      let xhr = new XMLHttpRequest();
      let response;
      xhr.open('POST', '/admin/attachments');
      xhr.onreadystatechange = () => {
        if (xhr.readyState != 4) {
          editor.classList.add('is-uploading');
          if (textarea) {
            textarea.setAttribute('disabled', true);
          }
        } else if (xhr.status != 201) {
          response = JSON.parse(xhr.response);
          editor.classList.add('is-error');
          reject(response);
        } else {
          response = JSON.parse(xhr.response);
          editor.classList.add('is-success');
          resolve(response);
        }
      }
      xhr.send(ajaxData);
    });
    promise.then(response => {
      console.log(response.message);
      editor.classList.remove('is-uploading');
      if (textarea) {
        textarea.removeAttribute('disabled');
        const imageTag = self.detectImageTag(file, response.url);
        self.insertImage(imageTag);
      }
    }).catch(response => {
      if (textarea) {
        textarea.removeAttribute('disabled');
        console.error(response.message);
      }
    });
    return promise;
  };

  insertImage(imageTag) {
    const textarea = this.editor.querySelector('textarea');

    if (!textarea) {
      return;
    }

    let beforeSelect = textarea.value.substr(0, textarea.selectionStart);
    let afterSelect = textarea.value.substr(textarea.selectionStart, textarea.value.length - 1);
    textarea.value = `${beforeSelect}${imageTag}${afterSelect}`;
  };

  detectImageTag(file, url) {
    let imageTag;
    const markup = document.querySelector('select[id$=_markup] option:checked').value;
    switch (markup) {
      case 'kramdown':
      case 'redcarpet':
        imageTag = '![' + file.name + '](' + url + ')';
        break;
      case 'redcloth':
        imageTag = '!' + url + '!';
        break;
      case 'html':
      case 'wikicloth':
      default:
        imageTag = '<img src="' + url + '" alt="' + file.name + '" />';
        break;
    }
    return imageTag;
  };
}

export default FileUploader
