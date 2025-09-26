enum MovementState {
  idle, // Standing still
  walking, // Normal walking speed (1-3 m/s)
  running, // Fast movement (3-6 m/s)
  teleporting, // Very fast movement (GPS jump)
}
