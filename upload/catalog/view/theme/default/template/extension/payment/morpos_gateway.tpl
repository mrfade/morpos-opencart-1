<link href="/catalog/view/theme/default/stylesheet/morpos.css" rel="stylesheet" type="text/css"/>

<!-- MorPOS Payment Method -->
<div class="morpos-payment-container">
  <div class="morpos-header">
    <div class="morpos-brand">
      <img src="/catalog/view/theme/default/image/payment/morpos-logo-small.png" alt="MorPOS" class="morpos-logo-img">
    </div>
    <div class="morpos-title"><?php echo isset($text_title) ? $text_title : 'MorPOS Payment'; ?></div>
    <img src="/catalog/view/theme/default/image/payment/card-logos.png" alt="Accepted Cards" class="morpos-card-logos-img">
  </div>
  <p class="morpos-description"><?php echo isset($text_description) ? $text_description : ''; ?></p>
</div>

<div class="buttons">
  <div class="pull-right">
    <input type="button" value="<?php echo isset($button_confirm) ? $button_confirm : 'Confirm Order'; ?>" id="button-confirm" data-loading-text="<?php echo isset($text_loading) ? $text_loading : 'Loading...'; ?>" class="btn btn-primary" />
  </div>
</div>

<!-- Modal HTML -->
<div id="morpos-modal">
  <div id="morpos-modal-content">
    <button id="morpos-close-btn">×</button>
    
    <!-- Loading state -->
    <div id="morpos-loading">
      <div class="morpos-spinner"></div>
      <p class="morpos-loading-text"><?php echo isset($text_loading) ? $text_loading : 'Loading...'; ?></p>
    </div>
    
    <!-- Payment iframe -->
    <iframe id="morpos-iframe"></iframe>
  </div>
</div>

<script type="text/javascript">
window.morposConfig = {
  confirmUrl: '<?php echo isset($confirm_url) ? addslashes($confirm_url) : ''; ?>',
  redirectSuccess: '<?php echo isset($redirect_success) ? addslashes($redirect_success) : ''; ?>',
  textPaymentFailedDefault: '<?php echo isset($text_payment_failed_default) ? addslashes($text_payment_failed_default) : 'Payment failed'; ?>',
  textPaymentInitFailed: '<?php echo isset($text_payment_init_failed) ? addslashes($text_payment_init_failed) : 'Payment initialization failed'; ?>',
  textNetworkError: '<?php echo isset($text_network_error) ? addslashes($text_network_error) : 'Network error'; ?>',
  textLoading: '<?php echo isset($text_loading) ? addslashes($text_loading) : 'Loading...'; ?>',
  textRedirecting: '<?php echo isset($text_redirecting) ? addslashes($text_redirecting) : 'Redirecting...'; ?>'
};
</script>
<script type="text/javascript" src="/catalog/view/theme/default/javascript/morpos.js"></script>
