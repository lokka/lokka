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
        let needLineBreak;
        for (const index in droppedItems) {
          const file = droppedItems[index].getAsFile();
          needLineBreak = index !== droppedItems.length;
          if (file && /^image\//.test(file.type)) {
            self.upload(file, needLineBreak);
          }
        }
        droppedItems = null;
        e.preventDefault();
      });
    });

    this.editor.dataset.uploadObserved = true;
  };

  upload(file, needLineBreak) {
    const editor = this.editor;
    const textarea = editor.querySelector('textarea');
    const ajaxData = new FormData();
    const self = this;
    ajaxData.append('file', file);
    fetch('/admin/attachments', {
      method: 'POST',
      body: ajaxData
    })
      .then(response => {
        if (textarea) {
          editor.classList.add('is-uploading');
          if (textarea) {
            textarea.setAttribute('disabled', true);
          }
        }
        response.json()
          .then(data => {
            console.log(data.message);
            editor.classList.add('is-success');
            if (textarea) {
              textarea.removeAttribute('disabled');
              const imageTag = self.detectImageTag(file, data.url);
              self.insertImage(imageTag, needLineBreak);
            }
          })
          .catch(data => {
            editor.classList.add('is-error');
            textarea.removeAttribute('disabled');
            console.error(data.message);
          })
          .finally(() => {
            editor.classList.remove('is-uploading');
          });
    });
  };

  insertImage(imageTag, needLineBreak) {
    const textarea = this.editor.querySelector('textarea');

    if (!textarea) {
      return;
    }

    let beforeSelect = textarea.value.substr(0, textarea.selectionStart);
    let afterSelect = textarea.value.substr(textarea.selectionStart, textarea.value.length - 1);
    if (needLineBreak) {
      textarea.value = `${beforeSelect}${imageTag}\n${afterSelect}`;
    } else {
      textarea.value = `${beforeSelect}${imageTag}${afterSelect}`;
    }
    let position = textarea.value.indexOf(afterSelect);
    textarea.setSelectionRange(position, position);
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
