import FormObserver from './FormObserver'
import FileUploader from './FileUploader'

let editor;

const initEditorUpload = () => {
  editor = document.querySelector('#editor');
  if (editor) {
    new FileUploader(editor);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  initEditorUpload();

  const textarea = document.querySelector('#editor textarea');
  if (textarea) {
    const formObserver = new FormObserver(textarea);
    document.querySelector('select[id$=_markup]').addEventListener('change', (event) => {
      formObserver.handleMarkupChange(event);
      initEditorUpload();
    }, false);
  }
});
