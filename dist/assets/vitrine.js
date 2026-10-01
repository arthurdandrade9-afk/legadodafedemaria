(async function () {
  const mount = document.querySelector('#vitrine-mount');
  const anchor = document.querySelector('#como-usar');
  if (!mount) return;
  if (anchor) anchor.after(mount);

  try {
    const response = await fetch('vitrine.html');
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    mount.innerHTML = await response.text();
  } catch (error) {
    mount.innerHTML = '<p class="vitrine-error">Não foi possível carregar as prévias agora. Recarregue a página.</p>';
    return;
  }

  const dialog = mount.querySelector('#preview-dialog');
  const image = dialog?.querySelector('img');
  const caption = dialog?.querySelector('figcaption');
  const close = dialog?.querySelector('.dialog-close');
  let trigger = null;

  mount.querySelectorAll('[data-preview]').forEach((button) => {
    button.addEventListener('click', () => {
      trigger = button;
      const source = button.getAttribute('data-preview');
      const thumbnail = button.querySelector('img');
      if (!dialog || !image || !source || !thumbnail) return;
      image.src = source;
      image.alt = thumbnail.alt;
      if (caption) caption.textContent = thumbnail.alt;
      dialog.showModal();
    });
  });

  close?.addEventListener('click', () => dialog.close());
  dialog?.addEventListener('click', (event) => {
    if (event.target === dialog) dialog.close();
  });
  dialog?.addEventListener('close', () => trigger?.focus());
})();
