//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap
//= require_tree .

function latestResponsesToggle() {
    $('.latest_response').off('click').on('click', function () {
        $(this).parents('.poke_form').find('.monospace_text').toggle();
    });
}