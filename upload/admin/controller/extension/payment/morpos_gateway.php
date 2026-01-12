<?php

class ControllerExtensionPaymentMorposGateway extends Controller
{
    private $error = array();

    /**
     * Get the correct route for this payment extension based on OpenCart version
     */
    private function getRoute($route = '')
    {
        // OpenCart 2.3+ uses 'extension/payment/' prefix
        // OpenCart 2.0-2.2 uses 'payment/' prefix
        if (version_compare(VERSION, '2.3.0', '>=')) {
            $base = 'extension/payment/morpos_gateway';
        } else {
            $base = 'payment/morpos_gateway';
        }
        
        return $route ? $base . '/' . $route : $base;
    }

    /**
     * Displays the main configuration page.
     *
     * @return void
     */
    public function index()
    {
        // Handle AJAX action for test connection
        if (isset($this->request->get['action']) && $this->request->get['action'] == 'testConnection') {
            return $this->testConnection();
        }

        $this->load->language('payment/morpos_gateway');
        $this->document->setTitle($this->language->get('method_title'));

        // Ensure table exists when admin visits configuration page
        $this->load->model('extension/payment/morpos_gateway');
        $this->model_extension_payment_morpos_gateway->ensureTableExists();

        $token = $this->session->data['token'];
        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link(
                'common/dashboard',
                'token=' . $token,
                'SSL'
            )
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_extension'),
            'href' => $this->url->link(
                version_compare(VERSION, '2.3.0', '>=')
                    ? 'extension/extension'
                    : 'extension/payment',
                'token=' . $token,
                'SSL'
            )
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('method_title'),
            'href' => $this->url->link(
                $this->getRoute(),
                'token=' . $token,
                'SSL'
            )
        );

        $data['token'] = $token;
        $data['action'] = $this->url->link(
            $this->getRoute(),
            'token=' . $token,
            'SSL'
        );
        $data['cancel'] = $this->url->link(
            version_compare(VERSION, '2.3.0', '>=')
                ? 'extension/extension'
                : 'extension/payment',
            'token=' . $token,
            'SSL'
        );
        $data['test_connection_url'] = $this->url->link(
            $this->getRoute(),
            'action=testConnection&token=' . $token,
            'SSL'
        );

        $this->load->model('setting/setting');

        $fields = array(
            'morpos_gateway_status',
            'morpos_gateway_testmode',
            'morpos_gateway_sort_order',
            'morpos_gateway_client_id',
            'morpos_gateway_client_secret',
            'morpos_gateway_merchant_id',
            'morpos_gateway_api_key',
            'morpos_gateway_form_type',
            'morpos_gateway_success_status_id',
            'morpos_gateway_failed_status_id',
            'morpos_gateway_connection_status',
        );

        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
            // Test connection before saving
            $connectionResult = $this->performConnectionTest($this->request->post);
            $connectionStatus = $connectionResult['success'] ? 'ok' : 'fail';

            // Update payment status based on connection result
            $this->request->post['morpos_gateway_connection_status'] = $connectionStatus;

            $this->model_setting_setting->editSetting('morpos_gateway', $this->request->post);

            $this->session->data['success'] = $this->language->get('text_success');

            $redirect_route = version_compare(VERSION, '2.3.0', '>=')
                ? 'extension/extension'
                : 'extension/payment';
            $this->response->redirect($this->url->link($redirect_route, 'token=' . $this->session->data['token'], 'SSL'));
        }

        foreach ($fields as $f) {
            if (isset($this->request->post[$f])) {
                $data[$f] = $this->request->post[$f];
            } else {
                $data[$f] = $this->config->get($f);
            }
        }

        $data['form_types'] = array(
            array(
                'value' => 'hosted',
                'text' => $this->language->get('text_hosted'),
            ),
            array(
                'value' => 'embedded',
                'text' => $this->language->get('text_embedded'),
            )
        );

        $this->load->model('localisation/order_status');
        $data['order_statuses'] = $this->model_localisation_order_status->getOrderStatuses();

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        if (isset($this->error['warning'])) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }

        $data['requirements'] = $this->getRequirementsInfo();
        $data['morpos_logo'] = 'view/image/payment/morpos-logo.png';

        // Load all language variables
        $language_keys = array(
            'method_title', 'button_save', 'button_cancel', 'method_description', 'morpos_gateway_version',
            'text_version2', 'text_morpos_logo_alt', 'text_setup', 'text_connection_successful', 'text_connection_failed',
            'text_test_connection', 'entry_status', 'text_enable', 'entry_test_mode', 'text_enable_test_mode',
            'text_test_mode_hint', 'entry_merchant_id', 'placeholder_merchant_id', 'entry_client_id', 'placeholder_client_id',
            'entry_client_secret', 'placeholder_client_secret', 'entry_api_key', 'placeholder_api_key', 'entry_form_type',
            'entry_success_status', 'entry_failed_status', 'entry_sort_order', 'placeholder_sort_order', 'text_save_changes',
            'text_system_requirements', 'text_server_status_description', 'text_requirements', 'text_component',
            'text_current', 'text_recommended', 'text_required', 'text_status', 'text_php_warning_hint',
            'text_tls_danger_hint', 'text_testing', 'text_connection_error', 'text_could_not_reach_server'
        );
        foreach ($language_keys as $key) {
            $data[$key] = $this->language->get($key);
        }

        $this->response->setOutput($this->load->view('payment/morpos_gateway.tpl', $data));
    }

    /**
     * Called when the extension is installed via admin Extensions -> Install.
     */
    public function install()
    {
        $this->load->model('extension/payment/morpos_gateway');
        $this->model_extension_payment_morpos_gateway->createTable();

        // Add permissions for all user groups
        $this->load->model('user/user_group');
        $this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', $this->getRoute());
        $this->model_user_user_group->addPermission($this->user->getGroupId(), 'modify', $this->getRoute());

        // Configure OpenCart for optimal payment gateway operation
        $this->configureOpenCartForPaymentGateways();
    }

    /**
     * Configure OpenCart settings for payment gateway compatibility
     * This ensures sessions work properly with external payment redirects
     */
    private function configureOpenCartForPaymentGateways()
    {
        $this->load->model('setting/setting');

        // Get current config
        $settings = $this->model_setting_setting->getSetting('config');
        $changed = false;

        // Set session SameSite policy to Lax for payment gateway compatibility (OC 2.3+)
        if (version_compare(VERSION, '2.3.0', '>=')) {
            if (!isset($settings['config_session_samesite']) || $settings['config_session_samesite'] === 'Strict') {
                $settings['config_session_samesite'] = 'Lax';
                $changed = true;
                if (isset($this->log)) {
                    $this->log->write('MorPOS Gateway: Updated session SameSite policy to Lax for payment gateways');
                }
            }
        }

        // Save the updated settings if changed
        if ($changed) {
            $this->model_setting_setting->editSetting('config', $settings);
        }
    }

    /**
     * Called when the extension is uninstalled via admin Extensions -> Uninstall.
     */
    public function uninstall()
    {
        $this->load->model('extension/payment/morpos_gateway');
        $this->model_extension_payment_morpos_gateway->dropTable();
    }

    /**
     * AJAX handler for testing the gateway connection.
     *
     * @return void
     */
    private function testConnection()
    {
        $this->load->language('payment/morpos_gateway');

        $json = array();

        // Permission check
        if (!$this->user->hasPermission('modify', $this->getRoute())) {
            $json['error']['warning'] = $this->language->get('error_permission');
        }

        if (!$json) {
            $connectionResult = $this->performConnectionTest($this->request->post);

            if ($connectionResult['success']) {
                $json['status'] = 'ok';
                $json['success'] = $connectionResult['message'];
            } else {
                $json['status'] = 'fail';
                $json['error'] = $connectionResult['error'];
            }
        }

        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    }

    /**
     * Performs connection test to MorPOS Gateway API.
     *
     * @param array $postData The POST data containing credentials and settings
     * @return array Array with 'success' boolean, 'message' or 'error' string
     */
    private function performConnectionTest($postData)
    {
        // Extract credentials from POST data
        $credentials = array();
        $fields = array('merchant_id', 'client_id', 'client_secret', 'api_key');

        // Handle direct POST data format
        foreach ($fields as $field) {
            $prefixedKey = 'morpos_gateway_' . $field;

            // Try prefixed key first, then credentials array, then non-prefixed key
            if (isset($postData[$prefixedKey]) && !empty($postData[$prefixedKey])) {
                $credentials[$field] = $postData[$prefixedKey];
            } elseif (isset($postData['credentials']) && isset($postData['credentials'][$field]) && !empty($postData['credentials'][$field])) {
                $credentials[$field] = $postData['credentials'][$field];
            } elseif (isset($postData[$field]) && !empty($postData[$field])) {
                $credentials[$field] = $postData[$field];
            } else {
                $credentials[$field] = '';
            }
        }

        // Validate required fields
        $isValid = true;
        foreach ($fields as $f) {
            if (empty($credentials[$f])) {
                $isValid = false;
                break;
            }
        }

        if (!$isValid) {
            return array(
                'success' => false,
                'error' => $this->language->get('error_please_fill_all_fields')
            );
        }

        // Determine test mode
        $testmode = false;
        if (isset($postData['morpos_gateway_testmode'])) {
            $testmode = in_array($postData['morpos_gateway_testmode'], array('1', 1, 'on'), true);
        } elseif (isset($postData['testmode'])) {
            $testmode = in_array($postData['testmode'], array('1', 1, 'on', 'yes', true), true);
        }

        try {
            // Load the MorPOS client library
            require_once DIR_SYSTEM . 'library/morpos/Client.php';

            // Create client instance
            $client = new MorposClient(
                $credentials['client_id'],
                $credentials['client_secret'],
                $credentials['merchant_id'],
                '',
                $credentials['api_key'],
                $testmode ? 'sandbox' : 'production'
            );

            $response = $client->makeTestConnection();

            $this->load->model('setting/setting');

            // Update payment status based on connection result
            $settings = $this->model_setting_setting->getSetting('morpos_gateway');
            $settings['morpos_gateway_connection_status'] = $response['ok'] === true ? 'ok' : 'fail';
            $this->model_setting_setting->editSetting('morpos_gateway', $settings);

            if ($response['ok']) {
                return array(
                    'success' => true,
                    'message' => $this->language->get('text_connection_successful')
                );
            } else {
                return array(
                    'success' => false,
                    'error' => $this->language->get('text_connection_failed')
                );
            }
        } catch (Exception $e) {
            return array(
                'success' => false,
                'error' => $this->language->get('text_connection_failed') . ': ' . $e->getMessage()
            );
        }
    }

    protected function validate()
    {
        if (!$this->user->hasPermission('modify', $this->getRoute())) {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        return !$this->error;
    }

    /**
     * Detects the TLS capability of the server.
     *
     * @return array
     */
    protected function detectTlsCapability()
    {
        $openssl_text = defined('OPENSSL_VERSION_TEXT') ? OPENSSL_VERSION_TEXT : null;
        $openssl_num = defined('OPENSSL_VERSION_NUMBER') ? OPENSSL_VERSION_NUMBER : null;
        $curl_info = function_exists('curl_version') ? curl_version() : null;

        // Derive minimal TLS supported via OpenSSL version heuristic
        $min_tls = 'unknown';
        if ($openssl_num) {
            if ($openssl_num < 0x1000100) {         // < 1.0.1
                $min_tls = '1.0';
            } elseif ($openssl_num < 0x1010100) {   // < 1.1.1
                $min_tls = '1.2';
            } else {
                $min_tls = '1.3';
            }
        }

        $label_parts = array();
        if ($openssl_text) {
            $label_parts[] = $openssl_text;
            if ($min_tls !== 'unknown') {
                $label_parts[] = sprintf('(TLS %s)', $min_tls);
            }
        } elseif ($curl_info && !empty($curl_info['ssl_version'])) {
            $label_parts[] = $curl_info['ssl_version'];
        } elseif ($curl_info && ($curl_info['features'] & CURL_VERSION_SSL)) {
            $label_parts[] = $this->language->get('text_ssl_tls_available_version_unknown');
        } else {
            $label_parts[] = $this->language->get('text_no_ssl_tls_detected');
        }

        return array(
            'label' => implode(' ', $label_parts),
            'min_tls' => $min_tls,
        );
    }

    /**
     * Gets the system requirements information.
     *
     * @return array
     */
    private function getRequirementsInfo()
    {
        $targets = array(
            'php' => array(
                'required' => '5.4',
                'recommended' => '5.6',
            ),
            'oc' => array(
                'required' => '2.0',
                'recommended' => '2.3',
            ),
            'tls' => array(
                'required' => '1.2',
                'recommended' => '1.3',
            ),
        );

        $current = array(
            'php' => PHP_VERSION,
            'oc' => VERSION,
            'tls' => $this->detectTlsCapability(),
        );

        $ver_status = function ($cur, $req, $rec) {
            if ($cur === null) {
                return array('class' => 'morpos-danger', 'hint' => $this->language->get('text_not_detected'));
            }

            if (version_compare($cur, $req, '<')) {
                return array('class' => 'morpos-danger', 'hint' => $this->language->get('text_below_required'));
            }

            if (version_compare($cur, $rec, '<')) {
                return array('class' => 'morpos-warning', 'hint' => $this->language->get('text_allowed_but_discouraged'));
            }

            return array('class' => 'morpos-ok', 'hint' => $this->language->get('text_meets_recommended'));
        };

        $tls_status = function ($current, $required, $recommended) {
            if (!$current || $current['min_tls'] === 'unknown') {
                return array(
                    'class' => 'morpos-danger',
                    'hint' => $this->language->get('text_unable_to_verify_tls_support')
                );
            }

            if (version_compare($current['min_tls'], $required, '<')) {
                return array('class' => 'morpos-danger', 'hint' => $this->language->get('text_below_required'));
            }

            if (version_compare($current['min_tls'], $recommended, '<')) {
                return array('class' => 'morpos-warning', 'hint' => $this->language->get('text_allowed_but_discouraged'));
            }

            return array('class' => 'morpos-ok', 'hint' => $this->language->get('text_meets_recommended'));
        };

        return array(
            array(
                'label' => $this->language->get('text_php'),
                'cur' => $current['php'],
                'req' => $targets['php']['required'] . '+',
                'rec' => $targets['php']['recommended'] . '+',
                'status' => $ver_status($current['php'], $targets['php']['required'], $targets['php']['recommended']),
            ),
            array(
                'label' => $this->language->get('text_opencart'),
                'cur' => $current['oc'],
                'req' => $targets['oc']['required'] . '+',
                'rec' => $targets['oc']['recommended'] . '+',
                'status' => $ver_status($current['oc'], $targets['oc']['required'], $targets['oc']['recommended']),
            ),
            array(
                'label' => $this->language->get('text_tls'),
                'cur' => $current['tls'] ? $current['tls']['label'] : $this->language->get('text_unknown'),
                'req' => 'TLS ' . $targets['tls']['required'] . '+',
                'rec' => 'TLS ' . $targets['tls']['recommended'] . '+',
                'status' => $tls_status($current['tls'], $targets['tls']['required'], $targets['tls']['recommended']),
            ),
        );
    }
}
