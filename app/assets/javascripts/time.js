$(document).on('turbolinks:load', function(){
  if($('.start_time').length){
    var id = $('.id_lesson').val();
    var path_now = window.location.pathname;
    var created_at = new Date($('.created_at').val()).getTime();
    var status_save = $('.status_save').val();
    var status_pass = $('.status_pass').val();
    var time_total = $('.time_total').val() * 1000;
    var status = get_status(status_save, status_pass);

    if(status){
      if(status == 1){
        var updated_at = new Date($('.updated_at').val()).getTime();
        var time_remain = time_total - updated_at + created_at;
      }else{
        var now = new Date().getTime();
        var time_remain = time_total - now + created_at;
      }
      time_running(time_remain, 1000, id, path_now, status);
    }
  }
});

function get_status(save, pass){
  if(pass.length != 0){
    return 0; //finished
  }else if(save == "true"){
    return 1; //saved
  }else{
    return 2; //unfinished
  }
}

function time_running(time_remain, time_step, id_lesson, path_name, status){
  var time_down = new Date().getTime() + time_remain;

  var my_time = setInterval(function(){
    var now = new Date().getTime();
    var distance = time_down - now;
    var minute = 1000 * 60;

    if (distance < 0) {
      clearInterval(my_time);
      if(window.location.pathname == path_name){
        alert("time over");
        $('#finish').click();
      }else{
        $.get('/finish_lesson_log/' + id_lesson + "/" + status,
          function(data) {});
      }
    }else{
      $('.minutes').text(Math.floor(distance / minute));
      $('.seconds').text(Math.floor((distance % minute) / 1000));
    }
  }, time_step);
}
