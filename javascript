# Print innertext of DOM with particular classname
document.querySelectorAll('[class*="nice-name"]').forEach(el => console.log(el.innetText));
