document.addEventListener('turbolinks:load', function () {
  let currentAction = document.body.getAttribute('data-action');
  let urlSetsContainer = document.querySelector('.form-container');

  // block.rbの定数MAX_URLSETS_COUNTと同じ値に
  const MAX_URLSETS = parseInt(
    document.body.getAttribute('data-max-urlsets'),
    10
  );

  // [Add_action]ユーザーが追加ボタンを押した時
  if (currentAction == 'new' || currentAction == 'create') {
    let addUrlSetButton = document.getElementById('add-url-set');

    addUrlSetButton.addEventListener('click', function (event) {
      event.preventDefault();
      if (countUrlSets() >= MAX_URLSETS) {
        alert(`最大${MAX_URLSETS}個までです。`);
      } else {
        addUrlSet();
      }
    });
  }

  // [Remove_action]ユーザーが削除ボタンを押した時
  document.addEventListener('click', function (event) {
    if (event.target.classList.contains('urlset-remove-btn')) {
      event.preventDefault();
      removeUrlSet(event.target.closest('.url-set'));
    }
  });

  // 以下[action]で使用するfunction

  // [Add_action]
  function addUrlSet() {
    let newUrlSet = document.querySelector('.url-set').cloneNode(true);
    let newIndex = countUrlSets();

    newUrlSet.querySelector(
      '.url-set-name input'
    ).name = `block[urlsets_attributes][${newIndex}][name]`;
    newUrlSet.querySelector('.url-set-name input').value = '';
    newUrlSet.querySelector(
      '.url-set-name input'
    ).id = `block_urlsets_attributes_${newIndex}_name`;

    newUrlSet.querySelector(
      '.url-set-address input'
    ).name = `block[urlsets_attributes][${newIndex}][address]`;
    newUrlSet.querySelector('.url-set-address input').value = '';
    newUrlSet.querySelector(
      '.url-set-address input'
    ).id = `block_urlsets_attributes_${newIndex}_address`;

    urlSetsContainer.appendChild(newUrlSet);
    showOrHideRemoveButtons();

    // 追加したURLセットからfield_with_errorsクラスを削除
    removeFieldWithErrorsClassFromNewUrlSets(newUrlSet);
  }

  function removeFieldWithErrorsClassFromNewUrlSets(newUrlSet) {
    let divsWithFieldWithErrors =
      newUrlSet.querySelectorAll('.field_with_errors');

    // 各field_with_errorsクラスを持つ<div>要素に対して処理
    divsWithFieldWithErrors.forEach((divElement) => {
      let childElement = divElement.querySelector('input, label');

      if (childElement) {
        divElement.parentNode.insertBefore(childElement, divElement);
        divElement.remove();
      }
    });
  }

  // [Remove_action]
  function removeUrlSet(urlSet) {
    urlSet.remove();
    showOrHideRemoveButtons();
  }

  // [Add_action],[Remove_action]
  function showOrHideRemoveButtons() {
    let allRemoveButtons = document.querySelectorAll('.urlset-remove-btn');
    if (countUrlSets() <= 1) {
      allRemoveButtons.forEach((button) => {
        button.style.display = 'none';
      });
    } else {
      allRemoveButtons.forEach((button) => {
        button.style.display = 'inline-block';
      });
    }
  }

  function countUrlSets() {
    return urlSetsContainer.querySelectorAll('.url-set').length;
  }

  if (currentAction == 'new' || currentAction == 'create') {
    // ページ読み込み時に削除ボタンの表示を設定する
    showOrHideRemoveButtons();
  }
});
