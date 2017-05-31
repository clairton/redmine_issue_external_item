window.onload = function () {
  Sortable.create('external_item_form_items', {tag: 'span'});
};

var Redmine = Redmine || {};

Redmine.IssueExternalItem = Class.create({
  initialize: function (element, key, quantity, input, button) {
    this.element   = $(element);
    this.input     = $(input);
    this.key     = $(key);
    this.quantity     = $(quantity);
    this.button    = $(button);
    this.external_item = new Hash();

    Event.observe(this.button, 'click', this.readExternalItem.bindAsEventListener(this));
    Event.observe(this.input, 'keypress', this.onKeyPress.bindAsEventListener(this));
    Event.observe(this.key, 'keypress', this.onKeyPress.bindAsEventListener(this));
    Event.observe(this.quantity, 'keypress', this.onKeyPress.bindAsEventListener(this));
  },

  readExternalItem: function (event) {
    this.addExternalItemItem(this.input.value, this.input.key, this.quantity.value);
    this.input.value = '';
    this.key.value = '';
    this.quantity.value = '';
    Event.stop(event);
  },

  onKeyPress: function (event) {
    if (Event.KEY_RETURN == event.keyCode) {
      this.readExternalItem(event);
      Event.stop(event);
    }
  },

  addExternalItemItem: function (сhecklistItem, key, quantity, isDone) {
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
    var label    = new Element('span', {'class': 'external_item-item'}).insert(hidden).insert(keyInput).insert(quantityInput).insert(checkbox).insert(label.strip()).insert(button);

    if (isDone == true) {
      checkbox.setAttribute('checked', 'checked');
      label.addClassName('is-done-external_item-item');
    }

    this.external_item.set(сhecklistItem, 1);
    this.element.insert({'bottom': label});

    Event.observe(button, 'click', function () {
      this.external_item.unset(сhecklistItem);
      label.remove();
      // Event.stop(event);
    }.bind(this));
    Event.observe(checkbox, 'click', function () {
      if (checkbox.checked == true) {
        label.addClassName('is-done-external_item-item');
      }
      else {
        label.removeClassName('is-done-external_item-item');
      }

    }.bind(this));

  },

  addExternalItem: function (external_item) {
    for (var i = 0; i < external_item.length; i++) {
      this.addExternalItemItem(external_item[i]['subject'], external_item[i]['key'], external_item[i]['quantity'], external_item[i]['is_done']);
    }
  },

  getExternalItem: function () {
    return this.external_item;
  },

});

function observeIssueExternalItemField(element, input, key, quantity, add_button) {
  issueExternalItem = new Redmine.IssueExternalItem(element, input, key, quantity, add_button);
}

function createIssueExternalItem(checkList) {
  issueExternalItem.addExternalItem(checkList);
}

function external_item_item_done(elem, url, id) {
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
      checkbox.up().addClassName('is-done-external_item-item');
    else
      checkbox.up().removeClassName('is-done-external_item-item');
}