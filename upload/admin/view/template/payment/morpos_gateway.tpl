<?php echo $header; ?>
<link href="view/stylesheet/morpos-admin.css" rel="stylesheet" type="text/css"/>
<link href="view/stylesheet/morpos-toast.css" rel="stylesheet" type="text/css"/>
<script src="view/javascript/morpos-toast.js" type="text/javascript"></script>
<?php echo $column_left; ?>
<div id="content">
<div class="page-header">
<div class="container-fluid">
<div class="pull-right">
<button type="submit" form="form-payment" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary">
<i class="fa fa-save"></i>
</button>
<a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default">
<i class="fa fa-reply"></i>
</a>
</div>
<h1><?php echo $method_title; ?></h1>
<ul class="breadcrumb">
<?php foreach ($breadcrumbs as $breadcrumb): ?>
<li>
<a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
</li>
<?php endforeach; ?>
</ul>
</div>
</div>
  <div class="container-fluid">
    <?php if (isset($error_warning) && $error_warning): ?>
    <div class="alert alert-danger alert-dismissible"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php endif; ?>

    <div class="morpos-settings">
      <div class="morpos-header">
        <div class="header-left">
          <h2 class="morpos-h2"><?php echo $method_title; ?></h2>
          <p class="morpos-desc"><?php echo $method_description; ?></p>
          <p class="morpos-version"><?php echo $text_version2; ?> <?php echo $morpos_gateway_version; ?></p>
        </div>
        <div class="header-right">
          <img class="morpos-logo" src="<?php echo $morpos_logo; ?>" alt="<?php echo $text_morpos_logo_alt; ?>"/>
        </div>
      </div>

      <div class="morpos-connection">
        <span class="pill pill-setup"><?php echo $text_setup; ?></span>
        <span class="pill pill-ok"><?php echo $text_connection_successful; ?></span>
        <span class="pill pill-fail"><?php echo $text_connection_failed; ?></span>
        <button type="button" class="button button-primary morpos-test-btn"><?php echo $text_test_connection; ?></button>
      </div>

      <form id="form-payment" class="form" action="<?php echo $action; ?>" method="post">
        <div class="field-row">
          <div class="label"><?php echo $entry_status; ?></div>
          <div class="field">
            <label class="cbx">
              <input type="checkbox" id="enabled" name="morpos_gateway_status" <?php echo (isset($morpos_gateway_status) && ($morpos_gateway_status == '1' || $morpos_gateway_status == 'on')) ? 'checked' : ''; ?>>
              <span class="cbx__box" aria-hidden="true">
                <svg class="cbx__check" viewbox="0 0 24 24" width="16" height="16">
                  <path d="M5 12.5l4 4L19 7.5"></path>
                </svg>
              </span>
              <span class="cbx__label"><?php echo $text_enable; ?></span>
            </label>
          </div>
        </div>

        <div class="field-row">
          <div class="label"><?php echo $entry_test_mode; ?></div>
          <div class="field">
            <label class="cbx cbx--warn">
              <input type="checkbox" id="testmode" name="morpos_gateway_testmode" <?php echo (isset($morpos_gateway_testmode) && ($morpos_gateway_testmode == '1' || $morpos_gateway_testmode == 'on')) ? 'checked' : ''; ?>>
              <span class="cbx__box" aria-hidden="true">
                <svg class="cbx__check" viewbox="0 0 24 24" width="16" height="16">
                  <path d="M5 12.5l4 4L19 7.5"></path>
                </svg>
              </span>
              <span class="cbx__label"><?php echo $text_enable_test_mode; ?></span>
              <span class="cbx__hint"><?php echo $text_test_mode_hint; ?></span>
            </label>
          </div>
        </div>

        <div class="field-row">
          <label class="label" for="merchant_id"><?php echo $entry_merchant_id; ?></label>
          <div class="field">
            <input id="merchant_id" type="text" placeholder="<?php echo $placeholder_merchant_id; ?>" name="morpos_gateway_merchant_id" value="<?php echo isset($morpos_gateway_merchant_id) ? $morpos_gateway_merchant_id : ''; ?>" autocomplete="off" required>
          </div>
        </div>

        <div class="field-row">
          <label class="label" for="client_id"><?php echo $entry_client_id; ?></label>
          <div class="field">
            <input id="client_id" type="text" placeholder="<?php echo $placeholder_client_id; ?>" name="morpos_gateway_client_id" value="<?php echo isset($morpos_gateway_client_id) ? $morpos_gateway_client_id : ''; ?>" autocomplete="off" required>
          </div>
        </div>

<div class="field-row">
<label class="label" for="client_secret"><?php echo $entry_client_secret; ?></label>
<div class="field">
<input id="client_secret" type="password" placeholder="<?php echo $placeholder_client_secret; ?>" name="morpos_gateway_client_secret" value="<?php echo isset($morpos_gateway_client_secret) ? $morpos_gateway_client_secret : ''; ?>" autocomplete="off" required>
</div>
</div>

        <div class="field-row">
          <label class="label" for="api_key"><?php echo $entry_api_key; ?></label>
          <div class="field">
            <input id="api_key" type="password" placeholder="<?php echo $placeholder_api_key; ?>" name="morpos_gateway_api_key" value="<?php echo isset($morpos_gateway_api_key) ? $morpos_gateway_api_key : ''; ?>" autocomplete="off" required>
          </div>
        </div>

        <div class="field-row">
          <label class="label" for="form_type"><?php echo $entry_form_type; ?></label>
          <div class="field">
            <select id="form_type" aria-label="<?php echo $entry_form_type; ?>" name="morpos_gateway_form_type">
              <?php foreach ($form_types as $form_type): ?>
                <option value="<?php echo $form_type['value']; ?>" <?php echo (isset($morpos_gateway_form_type) && $form_type['value'] == $morpos_gateway_form_type) ? 'selected' : ''; ?>><?php echo $form_type['text']; ?></option>
              <?php endforeach; ?>
            </select>
          </div>
        </div>

        <div class="field-row">
          <label class="label" for="success_status"><?php echo $entry_success_status; ?></label>
          <div class="field">
            <select id="success_status" aria-label="<?php echo $entry_success_status; ?>" name="morpos_gateway_success_status_id">
              <?php foreach ($order_statuses as $status): ?>
                <option value="<?php echo $status['order_status_id']; ?>" <?php echo (isset($morpos_gateway_success_status_id) && $status['order_status_id'] == $morpos_gateway_success_status_id) ? 'selected' : ''; ?>><?php echo $status['name']; ?></option>
              <?php endforeach; ?>
            </select>
          </div>
        </div>

        <div class="field-row">
          <label class="label" for="failed_status"><?php echo $entry_failed_status; ?></label>
          <div class="field">
            <select id="failed_status" aria-label="<?php echo $entry_failed_status; ?>" name="morpos_gateway_failed_status_id">
              <?php foreach ($order_statuses as $status): ?>
                <option value="<?php echo $status['order_status_id']; ?>" <?php echo (isset($morpos_gateway_failed_status_id) && $status['order_status_id'] == $morpos_gateway_failed_status_id) ? 'selected' : ''; ?>><?php echo $status['name']; ?></option>
              <?php endforeach; ?>
            </select>
          </div>
        </div>

        <div class="field-row">
          <label class="label" for="sort_order"><?php echo $entry_sort_order; ?></label>
          <div class="field">
            <input id="sort_order" type="number" placeholder="<?php echo $placeholder_sort_order; ?>" name="morpos_gateway_sort_order" value="<?php echo isset($morpos_gateway_sort_order) ? $morpos_gateway_sort_order : ''; ?>">
          </div>
        </div>

        <input type="hidden" name="morpos_gateway_connection_status" value="<?php echo isset($morpos_gateway_connection_status) ? $morpos_gateway_connection_status : ''; ?>">

        <div class="actions">
          <button class="button" type="submit"><?php echo $text_save_changes; ?></button>
        </div>
      </form>

      <div class="morpos-requirements">
        <h2><?php echo $text_system_requirements; ?></h2>
        <p><?php echo $text_server_status_description; ?></p>
        <div class="morpos-reqs">
          <div class="morpos-reqs__head"><?php echo $text_requirements; ?></div>
          <table>
            <thead>
              <tr>
                <th><?php echo $text_component; ?></th>
                <th class="col-current"><?php echo $text_current; ?></th>
                <th><?php echo $text_recommended; ?></th>
                <th><?php echo $text_required; ?></th>
                <th class="col-status"><?php echo $text_status; ?></th>
              </tr>
            </thead>
            <tbody>
              <?php foreach ($requirements as $row): ?>
                <tr>
                  <td><?php echo htmlspecialchars($row['label']); ?></td>
                  <td><?php echo htmlspecialchars($row['cur']); ?></td>
                  <td><?php echo htmlspecialchars($row['rec']); ?></td>
                  <td><?php echo htmlspecialchars($row['req']); ?></td>
                  <td>
                    <span class="morpos-badge <?php echo htmlspecialchars($row['status']['class']); ?>">
                      <?php if ($row['status']['class'] == 'morpos-ok'): ?>
                        &#x2714;
                      <?php elseif ($row['status']['class'] == 'morpos-warning'): ?>
                        &#9888;&#xfe0f;
                      <?php elseif ($row['status']['class'] == 'morpos-danger'): ?>
                        &#10060;
                      <?php endif; ?>
                      <?php echo htmlspecialchars($row['status']['hint']); ?>
                    </span>

                    <?php if (isset($text_php_warning_hint) && $row['status']['class'] == 'morpos-warning' && $row['label'] == 'PHP'): ?>
                      <span class="morpos-hint"><?php echo htmlspecialchars($text_php_warning_hint); ?></span>
                    <?php endif; ?>
                    <?php if (isset($text_tls_danger_hint) && $row['status']['class'] == 'morpos-danger'): ?>
                      <span class="morpos-hint"><?php echo htmlspecialchars($text_tls_danger_hint); ?></span>
                    <?php endif; ?>
                    <?php if ($row['label'] == 'TLS' && $row['status']['class'] == 'morpos-danger'): ?>
                      <span class="morpos-hint"><?php echo htmlspecialchars($text_tls_danger_hint); ?></span>
                    <?php endif; ?>
                  </td>
                </tr>
              <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
jQuery(function ($) {
  function setStatus(s) { // 'setup' | 'ok' | 'fail'
    $('.morpos-connection .pill').css('opacity', .35);
    if (s === 'ok') {
      $('.pill-ok').css('opacity', 1);
    } else if (s === 'fail') {
      $('.pill-fail').css('opacity', 1);
    } else {
      $('.pill-setup').css('opacity', 1);
    }

    $('[name="morpos_gateway_connection_status"]').val(s);
  }

  function readField(id) {
    return $('#' + id).val() || '';
  }

  $('.morpos-test-btn').on('click', function () {
    const $btn = $(this);
    $btn.prop('disabled', true).text('<?php echo $text_testing; ?>');

    const credentials = {
      merchant_id: readField('merchant_id'),
      client_id: readField('client_id'),
      client_secret: readField('client_secret'),
      api_key: readField('api_key'),
    };

    $.post(<?php echo json_encode(html_entity_decode($test_connection_url, ENT_QUOTES, 'UTF-8')); ?>, {
      credentials: credentials,
      testmode: $('#testmode').is(':checked') ? 'yes' : 'no'
    })
      .done(function (res) {
        if (res.success) {
          const s = res.status === 'ok' ? 'ok' : 'fail';
          setStatus(s);
          toast({
            color: s === 'ok' ? 'success' : 'danger',
            title: s === 'ok' ? '<?php echo $text_connection_successful; ?>' : '<?php echo $text_connection_failed; ?>',
            duration: 4000
          });
        } else {
          setStatus('fail');
          toast({
            color: 'danger',
            title: '<?php echo $text_connection_error; ?>',
            duration: 4000
          });
        }
      })
      .fail(function () {
        setStatus('fail');
        toast({
          color: 'danger',
          title: '<?php echo $text_could_not_reach_server; ?>',
          duration: 4000
        });
      })
      .always(function () {
        $btn.prop('disabled', false).text('<?php echo $text_test_connection; ?>');
      });
  });

  setStatus('<?php echo isset($morpos_gateway_connection_status) ? $morpos_gateway_connection_status : 'setup'; ?>');
});
</script>
<?php echo $footer; ?>
