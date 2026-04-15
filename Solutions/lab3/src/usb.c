#include "usb.h"
const struct device *cdc_dev = DEVICE_DT_GET(DT_NODELABEL(cdc_acm_uart));

USBD_DEVICE_DEFINE(usbd_ctx, DEVICE_DT_GET(DT_NODELABEL(zephyr_udc0)), 0x04D8, 0x000A);

USBD_DESC_LANG_DEFINE(lang_desc);
USBD_DESC_MANUFACTURER_DEFINE(mfr_desc, "Microchip Technology Inc.");
USBD_DESC_PRODUCT_DEFINE(prod_desc, "Zephyr CDC-ACM");
USBD_DESC_SERIAL_NUMBER_DEFINE(sn_desc);

USBD_DESC_CONFIG_DEFINE(fs_cfg_desc, "FS Configuration");
USBD_CONFIGURATION_DEFINE(fs_config, USB_SCD_SELF_POWERED, 50, &fs_cfg_desc);

void usb_msg_callback(struct usbd_context *const ctx, const struct usbd_msg *const msg)
{
    if (usbd_can_detect_vbus(ctx)) {
        switch (msg->type)
        {
        case USBD_MSG_VBUS_READY:
            manage_usb_device(true);
            break;
        case USBD_MSG_VBUS_REMOVED:
            manage_usb_device(false);
            break;
        default:
            break;
        }
    }
}

bool managed_vbus;
int init_usb_device(void)
{

    int err = 0;
    err = usbd_add_descriptor(&usbd_ctx, &lang_desc);
    if (err) {
        return err;
    }
    err = usbd_add_descriptor(&usbd_ctx, &mfr_desc);
    if (err) {
        return err;
    }
    err = usbd_add_descriptor(&usbd_ctx, &prod_desc);
    if (err) {
        return err;
    }
    err = usbd_add_descriptor(&usbd_ctx, &sn_desc);
    if (err) {
        return err;
    }

    err = usbd_add_configuration(&usbd_ctx, USBD_SPEED_FS, &fs_config);
    if (err) {
        return err;
    }

    err = usbd_register_class(&usbd_ctx, "cdc_acm_0", USBD_SPEED_FS, 1);
    if (err) {
        return err;
    }

    err = usbd_msg_register_cb(&usbd_ctx, usb_msg_callback);
    if (err) {
        return err;
    }

    err = usbd_init(&usbd_ctx);
    if (err) {
        return err;
    }

    managed_vbus = usbd_can_detect_vbus(&usbd_ctx);
    return err;

}

void manage_usb_device(bool connected)
{

    if (connected) {
        usbd_enable(&usbd_ctx);
        uint32_t dtr = 0;
        while (!dtr) {
            uart_line_ctrl_get(cdc_dev, UART_LINE_CTRL_DTR, &dtr);
            k_sleep(K_MSEC(100));
        }
        data_to_send.length = sprintf(data_to_send.buf, "\nPress T on the keyboard to toggle the LED 0\n - or -\nPress SW0 on the board to receive a message\n\n");
        uart_irq_tx_enable(cdc_dev);
    }
    else {
        usbd_disable(&usbd_ctx);
    }

}
