from datetime import datetime, timedelta
import re

def get_two_hour_from_now_raw():
    now = datetime.now()
    next_hour = (now + timedelta(hours=2)).replace(minute=0, second=0, microsecond=0)
    return next_hour.strftime("%H:%M")

def get_current_time_raw():
    return datetime.now().strftime("%H:%M")

def add_minutes_to_time_raw(time_str, minutes):
    dt = datetime.strptime(time_str, "%H:%M")
    new_dt = dt + timedelta(minutes=minutes)
    return new_dt.strftime("%H:%M")

def convert_to_12h_raw(time_24h: str) -> str:
    t = datetime.strptime(time_24h, "%H:%M")
    return t.strftime("%-I:%M %p")  # np. '1:00 PM'

def normalize_time_string(value):
    """Remove non-breaking and thin spaces (U+200A, U+2009, U+00A0)"""
    return re.sub(r"[\u200A\u2009\u00A0]", " ", value)


