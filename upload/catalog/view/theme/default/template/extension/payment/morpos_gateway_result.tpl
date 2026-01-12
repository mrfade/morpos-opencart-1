<!doctype html>
<meta charset="utf-8">
<title><?php echo isset($text_processing_title) ? $text_processing_title : 'Processing Payment'; ?></title>
<style>
  body {
    font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
    margin: 0;
    padding: 1rem;
    text-align: center;
    background: white;
    color: #333;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
  }
  .result-container {
    max-width: 350px;
    width: 100%;
    padding: 0.5rem;
  }
  .status-icon {
    font-size: 2.5rem;
    margin-bottom: 0.75rem;
    display: block;
  }
  .success { color: #22c55e; }
  .error { color: #ef4444; }
  .status-title {
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 0.75rem;
  }
  .status-message {
    margin-bottom: 1rem;
    color: #666;
    line-height: 1.4;
    font-size: 0.9rem;
  }
  .error-details {
    background: #fef2f2;
    border-left: 4px solid #ef4444;
    padding: 0.75rem;
    margin-bottom: 1rem;
    color: #dc2626;
    text-align: left;
    font-size: 0.85rem;
  }
  .redirect-info {
    font-size: 0.8rem;
    color: #999;
  }
</style>
<script>
  (function () {
    const status = '<?php echo isset($status) ? $status : 'failure'; ?>';
    const errorMessage = '<?php echo isset($error_message) ? addslashes($error_message) : ""; ?>';
    
    if (window.parent && window.parent !== window) {
      window.parent.postMessage({
        type: 'MORPOS_RESULT',
        status: status,
        message: errorMessage,
        redirect_url: '<?php echo isset($redirect_url) ? addslashes($redirect_url) : ''; ?>',
        order_id: '<?php echo isset($order_id) ? $order_id : ''; ?>',
        order_status: '<?php echo isset($order_status) ? $order_status : ''; ?>',
      }, window.location.origin);
    } else {
      // If not in iframe, redirect after showing message briefly
      setTimeout(function() {
        window.location.href = '<?php echo isset($redirect_url) ? $redirect_url : '/'; ?>';
      }, status === 'success' ? 1500 : 3000); // Longer delay for errors
    }
  })();
</script>

<body>
  <div class="result-container">
    <?php if (isset($status) && $status == 'success'): ?>
      <div class="status-icon success">✅</div>
      <div class="status-title success"><?php echo isset($text_payment_successful) ? $text_payment_successful : 'Payment Successful'; ?></div>
      <div class="status-message"><?php echo isset($text_processing_message) ? $text_processing_message : 'Your payment has been processed successfully.'; ?></div>
    <?php else: ?>
      <div class="status-icon error">❌</div>
      <div class="status-title error"><?php echo isset($text_payment_failed) ? $text_payment_failed : 'Payment Failed'; ?></div>
      <?php if (isset($error_message) && $error_message): ?>
        <div class="error-details"><?php echo $error_message; ?></div>
      <?php endif; ?>
      <div class="status-message"><?php echo isset($text_redirect_retry) ? $text_redirect_retry : 'Please try again.'; ?></div>
    <?php endif; ?>
    
    <div class="redirect-info">
      <?php echo isset($text_redirecting_auto) ? $text_redirecting_auto : 'Redirecting...'; ?>
    </div>
  </div>
</body>
