window.onload = function() {
  $('#external_items_form').sortable();
};

var Redmine = Redmine || {};

$.fn.issue_external_items = function(element, input, key, quantity, button, fileInput) {};

Redmine.IssueExternalItem = jQuery.klass({
  init: function(element, input, key, quantity, button, fileInput) {
    this.element   = $('#' + element);
    this.input     = $('#' + input);
    this.key     = $('#' + key);
    this.quantity     = $('#' + quantity);
    this.button    = $('#' + button);
    this.fileInput = $('#' + fileInput);
    this.external_item = {};
    this.button.click($.proxy(this.readExternalItem, this));
    this.fileInput.on('change', $.proxy(this.onFileInputChange, this));

    this.input.keypress($.proxy(this.onKeyPress, this));
    this.input.on('dragover', $.proxy(this.onDragOver, this));
    this.input.on('drop', $.proxy(this.onDrop, this));


    this.key.keypress($.proxy(this.onKeyPress, this));
    this.key.on('dragover', $.proxy(this.onDragOver, this));
    this.key.on('drop', $.proxy(this.onDrop, this));

    this.quantity.keypress($.proxy(this.onKeyPress, this));
    this.quantity.on('dragover', $.proxy(this.onDragOver, this));
    this.quantity.on('drop', $.proxy(this.onDrop, this));
  },

  readExternalItem: function(event) {
    this.addExternalItemItem(this.input.val(), this.key.val(), this.quantity.val());
    this.input.val('');
    this.key.val('');
    this.quantity.val('');
    event.preventDefault();
  },

  onKeyPress: function(event) {
    if (13 == event.keyCode) {
      this.readExternalItem(event);
      event.preventDefault();
    }
  },

  addExternalItemItem: function(сhecklistItem, key, quantity, isDone, id) {
    if ($.isEmptyObject(сhecklistItem) || $.isEmptyObject(key) || $.isEmptyObject(quantity)) {
      return;
    }

    isDone = isDone || false;

    var hidden = $(document.createElement('input'));
    hidden.attr({'type': 'hidden', 'name': 'external_items[][subject]', 'value': $.trim(сhecklistItem)});

    var keyInput = $(document.createElement('input'));
    keyInput.attr({'type': 'hidden', 'name': 'external_items[][key]', 'value': $.trim(key)});

    var quantityInput = $(document.createElement('input'));
    quantityInput.attr({'type': 'hidden', 'name': 'external_items[][quantity]', 'value': $.trim(quantity)});

    var button = $(document.createElement('span'));
    button.attr({'href': '#', 'class': 'delete icon icon-del' });
    var checkbox = $(document.createElement('input'));
    checkbox.attr({'type': 'checkbox', 'name': 'external_items[][is_done]', 'value': '1', 'id': 'external_item_item_checkbox_'+id});
    var label  = $(document.createElement('span'));
    label.attr({ 'class': 'external_item-item' })
                  .append(hidden)
                  .append(keyInput)
                  .append(quantityInput)
                  .append(checkbox)
                  .append($.trim(key))
                  .append(' - ')
                  .append($.trim(сhecklistItem))
                  .append(' - ')
                  .append($.trim(quantity))
                  .append(button);

    if (isDone == true) {
      checkbox.attr('checked', 'checked');
      label.addClass('is-done-external_item-item');
    }

    this.external_item[сhecklistItem] = 1;
    this.element.append(label);

    button.click($.proxy(function(){
      this.external_item[сhecklistItem] = null;
      label.remove();
      // Event.stop(event);
    }, this));

    checkbox.click($.proxy(function(){
      if (checkbox.is(':checked')) {
        label.addClass('is-done-external_item-item');
      } else {
        label.removeClass('is-done-external_item-item');
      };
    }, this));

  },

  addExternalItem: function(external_item) {
    for (var i = 0; i < external_item.length; i++) {
      this.addExternalItemItem(external_item[i]['subject'], external_item[i]['key'], external_item[i]['quantity'], external_item[i]['is_done'], external_item[i]['id']);
    }
  },

  getExternalItem: function() {
    return this.external_item;
  },

  onDragOver: function(event) {
    event.stopPropagation();
    event.preventDefault();
    event.originalEvent.dataTransfer.dropEffect = 'copy';
  },

  onDrop: function(event) {
    var file = event.dataTransfer.files[0];

    event.stopPropagation();
    event.preventDefault();

    if (file) {
      this.parseMultiLineFile(file);
    }
  },

  onFileInputChange: function(event) {
    if(!event.target.files){
      return;
    }
    var file = event.target.files[0];
    if (file) {
      this.parseMultiLineFile(file);
    }
  },

  parseMultiLineFile: function (file) {
    if (!(window.File && window.FileReader) || !file ||
        !file.type.match('text.*')) {
      return false;
    }

    var _this = this;
    var reader = new window.FileReader();

    reader.onload = function(event) {
      var result = event.target.result;
      var lines = result.split("\n").filter(function(el) {
        return !$.isEmptyObject(el);
      });

      if (lines.length && window.confirm('Import ' + lines.length + ' external_item items?')) {
        lines.forEach(function(line) {
          _this.addExternalItemItem(line);
        });
      };
    };

    reader.readAsText(file);
  }
});

function observeIssueExternalItemField(element, input, key, quantity, add_button, fileInput) {
  issueExternalItem = new Redmine.IssueExternalItem(element, input, key, quantity, add_button, fileInput);
}

function createIssueExternalItem(checkList) {
  issueExternalItem.addExternalItem(checkList);
}

function external_item_item_done(elem,url,id){
  $.ajax({url: url,
          dataType: 'script',
          data: 'external_item_item_' + id});
  var checkbox = $('#external_item_item_checkbox_'+id);
  if (checkbox.is(':checked')) {
    checkbox.removeAttr('checked');
  } else {
    checkbox.attr('checked', true);
  }
}
