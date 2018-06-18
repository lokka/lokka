import FormObserver from './FormObserver'
import FileUploader from './FileUploader'

document.addEventListener('DOMContentLoaded', () => {
  const editor = document.querySelector('#editor');
  if (editor) {
    new FileUploader(editor);
  }

  const textarea = document.querySelector('#editor textarea');
  if (textarea) {
    const formObserver = new FormObserver(textarea);
    document.querySelector('select[id$=_markup]').addEventListener('change', (event) => {
      formObserver.handleMarkupChange(event);
    }, false);
  }
});
