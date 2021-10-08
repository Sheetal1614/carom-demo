//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap
//= require select2-full
//= require_tree .

function latestResponsesToggle() {
    $('.latest_response').off('click').on('click', function () {
        $(this).parents('.poke_form').find('.monospace_text').toggle();
    });
}

function readCronExpression() {
    $('.cron_exp_field').off('input').on('input', function () {
        let _cron_field_items = [];
        let _parent = $(this).closest('form');
        _parent.find('.cron_exp_field').each(function (i, e) {
            _cron_field_items.push($(e).val().toString());
        });

        let _cron_fields_string = _cron_field_items.join(' ');
        _parent.find('.cron_exp_label small').html(_cron_fields_string);

        $.ajax({
            type: 'POST',
            url: '/documents/cron_expression_description.js',
            data: {"cron_expression": _cron_fields_string},
            dataType: 'json',
            success: function (data) {
                _parent.find('.cron_exp_label small').html(data);
            }
        });
    });
}