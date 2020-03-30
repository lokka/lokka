import Quill from 'quill'
import FileUploader from './FileUploader'

class FormObserver {
  constructor(textarea) {
    this.textarea = textarea;
    this.selected = document.querySelector('select[id$=_markup] option:checked').value;
    this.setupEditor();
    this.observeSubmit();
    this.observePreview();
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
    const previewTab = document.querySelector('ul.preview-edit');
    previewTab.style.display = 'none';
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
    const previewTab = document.querySelector('ul.preview-edit');
    previewTab.style.display = 'block';
    this.quill = Quill.find(document.querySelector('#editor'));
    if (this.quill) {
      const qlToolbar = document.querySelector('.ql-toolbar');
      const qlContainer = document.querySelector('.ql-container');
      const content = this.quill.root.innerHTML;
      textarea.value = content;
      qlContainer.remove();
      qlToolbar.remove();
      const editor = document.createElement('div');
      editor.setAttribute('id', 'editor');
      editor.appendChild(textarea);
      previewTab.parentNode.insertBefore(editor, previewTab.nextSibling);
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

  observePreview() {
    let editor;
    const preview = document.querySelector('#preview');
    const markupSelect = document.querySelector('#post_markup, #page_markup');
    const previewRadio = document.querySelector('input[type="radio"][name="ipreview"][value="preview"]');
    const editRadio = document.querySelector('input[type="radio"][name="ipreview"][value="edit"]');
    markupSelect.addEventListener('change', (e) => {
      const selected = e.target.value;
      e.target.querySelectorAll('option').forEach((option) => {
        if (option.value == selected) {
          option.setAttribute('selected', 'selected');
        } else {
          option.removeAttribute('selected');
        }
      })
    });
    editRadio.addEventListener('change', (e) => {
      editor = document.querySelector('#editor');
      e.srcElement.parentElement.classList.add('selected');
      previewRadio.parentElement.classList.remove('selected');
      preview.style.display = 'none';
      editor.style.display = 'block';
      preview.innerHTML = '';
    });
    previewRadio.addEventListener('change', async (e) => {
      editor = document.querySelector('#editor');
      e.srcElement.parentElement.classList.add('selected');
      editRadio.parentElement.classList.remove('selected');
      const textarea = document.querySelector('#editor textarea');
      const raw_body = textarea.value;
      const markup = document.querySelector('#post_markup option:checked, #page_markup option:checked').value || 'redcarpet';
      const ajaxData = new FormData();
      ajaxData.append('raw_body', raw_body);
      ajaxData.append('markup', markup);
      const request = await fetch('/admin/previews', {
        method: 'POST',
        body: ajaxData
      });
      const response = await request.json();
      const iframe = document.createElement('iframe');
      preview.appendChild(iframe);
      const doc = iframe.contentWindow.document;
      const style = `<style>
img { max-width: 100%; }
img { height: auto; }
html, body {
  font-size: 16px;
  font-family: "Lucida Sans Unicode","Lucida Grande",Arial,Helvetica,"ヒラギノ角ゴ Pro W3",HiraKakuPro-W3,Osaka,sans-serif;
  word-wrap: break-word;
}
</style>`;
      const result = new Promise(resolve => resolve(iframe));
      const renderIframe = () => {
        doc.open();
        doc.write(style + response.body);
        doc.close();
      }
      const resizeIframe = () => {
        iframe.style.width = '100%';
        iframe.style.height = iframe.contentWindow.document.body.scrollHeight + 'px';
      }
      result.then(renderIframe).then(resizeIframe).catch(setTimeout(resizeIframe, 300));
      editor.style.display = 'none';
      preview.style.display = 'block';
    });
  }
}

export default FormObserver
