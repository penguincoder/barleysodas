function set_all_checkboxes(form_name, field_name, check_value)
{
  if(!document.forms[form_name])
    return;
  var objCheckBoxes = document.forms[form_name].elements[field_name];
  if(!objCheckBoxes)
    return;
  var countCheckBoxes = objCheckBoxes.length;
  if(!countCheckBoxes)
    objCheckBoxes.checked = check_value;
  else
    // set the check value for all check boxes
    for(var i = 0; i < countCheckBoxes; i++)
      objCheckBoxes[i].checked = check_value;
}
