const handleCheckboxChange = function(event){
  const el = event.target;
  if (el instanceof HTMLInputElement && el.type === "checkbox") {
    Rails.fire(el.form, 'submit');
  }
}

document.addEventListener('turbolinks:load', () => {
  const items = document.querySelector('#shopping-list-items');
  items.addEventListener('change', handleCheckboxChange, false);
});
