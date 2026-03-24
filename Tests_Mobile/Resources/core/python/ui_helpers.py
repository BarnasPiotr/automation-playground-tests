def log_element_info(element):
    try:
        attrs = {
            "text": element.text,
            "id": element.get_attribute("resourceId"),
            "bounds": element.get_attribute("bounds")
        }
        print(f"[DEBUG] Element info: {attrs}")
    except Exception as e:
        print(f"[ERROR] Could not log element info: {e}")