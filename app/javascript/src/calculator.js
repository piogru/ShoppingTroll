hideRecipe = function(){
  const fields = document.querySelectorAll(
    ".hide-recipe"
  );
  fields.forEach((element) => {
    element.style.display ='none';
  });
}
showRecipe = function(){
  const fields = document.querySelectorAll(
    ".hide-recipe"
  );
  fields.forEach((element) => {
    element.style.display ='block';
  });
}

hideHome = function(){
  const fields = document.querySelectorAll(
    ".hide-home"
  );
  fields.forEach((element) => {
    element.style.display ='none';
  });
}
showHome = function(){
  const fields = document.querySelectorAll(
    ".hide-home"
  );
  fields.forEach((element) => {
    element.style.display ='block';
  });
}

isNumber = function(evt) {
  evt = (evt) ? evt : window.event;
  let charCode = (evt.which) ? evt.which : evt.keyCode;
  if ((charCode > 31 && (charCode < 48 || charCode > 57)) && charCode !== 46) {
    evt.preventDefault();
    return false;
  } else {
    return true;
  }
}

addEventListener("load", () => {
  const numberFields = document.querySelectorAll(
    ('input[data-positive-number="true"]')
  );
  numberFields.forEach((element) => {
    element.addEventListener("keypress", isNumber)
  });
});
