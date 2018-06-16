import Quill from 'quill'

class FormObserver {
  constructor(textarea) {
    this.textarea = textarea;
    this.selected = document.querySelector('select[id$=_markup] option:checked').value;
    this.setupEditor();
    this.observeSubmit();
  }

  setupEditor() {
    if (this.selected === 'html' || this.selected === '') {
      this.setupQuill();
    } else {
      this.setupTextarea();
    }
  }

  handleMarkupChange(event) {
    if (event.target.querySelector('option:checked').value === 'html') {
      this.setupQuill();
    } else {
      this.setupTextarea();
    }
  }

  setupQuill() {
    const content = document.querySelector('#editor textarea').value;
    this.quill = new Quill('#editor', {
      modules: {
        toolbar:[
          [{ header: [3, 4, false] }],
          ['bold', 'link'],
          [{ list: 'ordered' }, { list: 'bullet' }],
          ['image', 'code-block']
        ]
      },
      theme: 'snow'
    });
    this.quill.clipboard.dangerouslyPasteHTML(content);
    this.quill.getModule('toolbar').addHandler('image', () => {
      this.selectLocalImage();
    });
  }

  setupTextarea() {
    const textarea = this.textarea;
    this.quill = Quill.find(document.querySelector('#editor'));
    if (this.quill) {
      const label = document.querySelector('label[for$="_body"]');
      const qlToolbar = document.querySelector('.ql-toolbar');
      const qlContainer = document.querySelector('.ql-container');
      const content = this.quill.root.innerHTML;
      textarea.value = content;
      qlContainer.remove();
      qlToolbar.remove();
      const editor = document.createElement('div');
      editor.setAttribute('id', 'editor');
      editor.appendChild(textarea);
      label.parentNode.insertBefore(editor, label.nextSibling);
    }
  }

  selectLocalImage() {
    const editor = document.querySelector('#editor');
    const input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');
    input.click();

    // Listen upload local image and save to server
    input.onchange = () => {
      const file = input.files[0];
      // file type is only image.
      if (/^image\//.test(file.type)) {
        const uploader = new FileUploader(editor);
        uploader.upload(file).then((response) => {
          const range = this.quill.getSelection();
          this.quill.insertEmbed(range.index, 'image', response.url);
        });
      } else {
        console.warn('You could only upload images.');
      }
    };
  }

  observeSubmit() {
    const form = document.querySelector('#main form');
    form.onsubmit = () => {
      this.setupTextarea();
    }
  }
}

export default FormObserver
