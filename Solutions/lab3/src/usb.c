#include "usb.h"

#define USB_DEVICE DEVICE_DT_GET(DT_NODELABEL(zephyr_udc0))

/* Get CDC-ACM UART device from devicetree */
#define CDC_ACM_DEVICE DEVICE_DT_GET(DT_NODELABEL(cdc_acm_uart))

const struct device *cdc_dev = CDC_ACM_DEVICE;

/* USB device context with MCHP VID and cdc_com_port_single demo PID  */
USBD_DEVICE_DEFINE(usbd_ctx,
                   USB_DEVICE,
                   0x04D8, 0x000A);

/* String descriptors */
USBD_DESC_LANG_DEFINE(lang_desc);
USBD_DESC_MANUFACTURER_DEFINE(mfr_desc, "Microchip Technology Inc.");
USBD_DESC_PRODUCT_DEFINE(prod_desc, "Zephyr CDC-ACM");
USBD_DESC_SERIAL_NUMBER_DEFINE(sn_desc);

/* USB Full-Speed configuration */
USBD_DESC_CONFIG_DEFINE(fs_cfg_desc, "FS Configuration");

USBD_CONFIGURATION_DEFINE(fs_config,
                          USB_SCD_SELF_POWERED,
                          250,  /* 500mA */
                          &fs_cfg_desc);

/* USB message Callback */
static void usb_msg_callback(struct usbd_context *const ctx,
                             const struct usbd_msg *msg)
{
    if (usbd_can_detect_vbus(ctx)) {
        if (msg->type == USBD_MSG_VBUS_READY) {
            if (usbd_enable(ctx)) {
                /* Error */
            }
        }
    
        if (msg->type == USBD_MSG_VBUS_REMOVED) {
            if (usbd_disable(ctx)) {
                /* Error */
            }
        }
    }
    
    if (msg->type == USBD_MSG_CONFIGURATION) {
        /* Device changed configuration */
    }

   	if (msg->type == USBD_MSG_CDC_ACM_CONTROL_LINE_STATE) {
        /* CDC ACM Line State update */
	}

    if (msg->type == USBD_MSG_CDC_ACM_LINE_CODING) {
        /* CDC ACM Line Coding update */
    }
}

/* USB device stack Initialization */
int init_usb_device(void)
{
    int err = 0;
    
    /* Adding Sting Descriptors */
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
    
    /* Adding Full-Speed configuration */
    err = usbd_add_configuration(&usbd_ctx, USBD_SPEED_FS, &fs_config);
    if (err) {
        return err;
    }
    
    /* Registering the CDC-ACM class */
    err = usbd_register_class(&usbd_ctx, "cdc_acm_0", USBD_SPEED_FS, 1);
    if (err) {
        return err;
    }
    
    /* Registering USB message callback */
    err = usbd_msg_register_cb(&usbd_ctx, usb_msg_callback);
    if (err) {
        return err;
    }
    
    /* Ititialize the USB device */
    err = usbd_init(&usbd_ctx);
    if (err) {
        return err;
    }
    
    /* If the controller doesnt support VBUS detection, enable it immediately */
    if (!usbd_can_detect_vbus(&usbd_ctx)) {
        err = usbd_enable(&usbd_ctx);
        if (err) {
            return err;
        }
    }
    
    return err;
}						  
