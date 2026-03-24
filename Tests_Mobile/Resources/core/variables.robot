*** Variables ***
${REMOTE}           http://127.0.0.1:4723
${DEVICE_NAME}      emulator-5554
${PKG}              com.google.android.deskclock
${ACT}              com.android.deskclock.DeskClock
${TIMEOUT}          1000
${FAB_ADD}          id=com.google.android.deskclock:id/fab
${OK_BTN}           id=com.google.android.deskclock:id/material_timepicker_ok_button
${ALARM_CARD}       xpath=//androidx.recyclerview.widget.RecyclerView/android.view.ViewGroup[1]
${ALARM_SWITCH}     xpath=(//android.widget.Switch)[1]
${DELETE_BTN}       id=com.google.android.deskclock:id/delete
${CONFIRM_BTN}      id=android:id/button1