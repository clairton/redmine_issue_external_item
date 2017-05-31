window.onload = function () {
  Sortable.create('checklist_form_items', {tag: 'span'});
};

var Redmine = Redmine || {};

Redmine.IssueChecklist = Class.create({
  initialize: function (element, key, quantity, input, button) {
    this.element   = $(element);
    this.input     = $(input);
    this.key     = $(key);
    this.quantity     = $(quantity);
    this.button    = $(button);
    this.checklist = new Hash();

    Event.observe(this.button, 'click', this.readChecklist.bindAsEventListener(this));
    Event.observe(this.input, 'keypress', this.onKeyPress.bindAsEventListener(this));
    Event.observe(this.key, 'keypress', this.onKeyPress.bindAsEventListener(this));
    Event.observe(this.quantity, 'keypress', this.onKeyPress.bindAsEventListener(this));
  },

  readChecklist: function (event) {
    this.addChecklistItem(this.input.value, this.input.key, this.quantity.value);
    this.input.value = '';
    this.key.value = '';
    this.quantity.value = '';
    Event.stop(event);
  },

  onKeyPress: function (event) {
    if (Event.KEY_RETURN == event.keyCode) {
      this.readChecklist(event);
      Event.stop(event);
    }
  },

  addChecklistItem: function (сhecklistItem, key, quantity, isDone) {
    if (сhecklistItem.blank() || key.blank() || quantity.blank()) return;

    isDone = isDone || false;

    var hidden   = new Element('input', {
      'type': 'hidden',
      'name': 'check_list_items[][subject]',
      'value': сhecklistItem.strip()
    });

    var keyInput   = new Element('input', {
      'type': 'hidden',
      'name': 'check_list_items[][key]',
      'value': key
    });

    var quantityInput   = new Element('input', {
      'type': 'hidden',
      'name': 'check_list_items[][quantity]',
      'value': quantity
    });

    var label = key + ' - ' + сhecklistItem + ' - ' + quantity; 

    var button   = new Element('span', {'href': '#', 'class': 'delete icon icon-del'});
    var checkbox = new Element('input', {'type': 'checkbox', 'name': 'check_list_items[][is_done]', 'value': '1'});
    var label    = new Element('span', {'class': 'checklist-item'}).insert(hidden).insert(keyInput).insert(quantityInput).insert(checkbox).insert(label.strip()).insert(button);

    if (isDone == true) {
      checkbox.setAttribute('checked', 'checked');
      label.addClassName('is-done-checklist-item');
    }

    this.checklist.set(сhecklistItem, 1);
    this.element.insert({'bottom': label});

    Event.observe(button, 'click', function () {
      this.checklist.unset(сhecklistItem);
      label.remove();
      // Event.stop(event);
    }.bind(this));
    Event.observe(checkbox, 'click', function () {
      if (checkbox.checked == true) {
        label.addClassName('is-done-checklist-item');
      }
      else {
        label.removeClassName('is-done-checklist-item');
      }

    }.bind(this));

  },

  addChecklist: function (checklist) {
    for (var i = 0; i < checklist.length; i++) {
      this.addChecklistItem(checklist[i]['subject'], checklist[i]['key'], checklist[i]['quantity'], checklist[i]['is_done']);
    }
  },

  getChecklist: function () {
    return this.checklist;
  },

});

function observeIssueChecklistField(element, input, key, quantity, add_button) {
  issueChecklist = new Redmine.IssueChecklist(element, input, key, quantity, add_button);
}

function createIssueChecklist(checkList) {
  issueChecklist.addChecklist(checkList);
}

function checklist_item_done(elem, url, id) {
  new Ajax.Request(url,
    {
      method: 'get',
      onSuccess: function (transport) {
        var response = transport.responseText || "no response text";
        eval(response)
      },
      onFailure: function () {
        alert('Something went wrong...')
      }
    });

  var checkbox = $(elem)
  if (checkbox)
    if (checkbox.checked)
      checkbox.up().addClassName('is-done-checklist-item');
    else
      checkbox.up().removeClassName('is-done-checklist-item');
}