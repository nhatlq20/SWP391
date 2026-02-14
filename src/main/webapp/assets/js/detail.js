function decreaseQty() {
  const input = document.getElementById("quantity");
  if (input.value > 1) {
    input.value = parseInt(input.value) - 1;
  }
}

function increaseQty() {
  const input = document.getElementById("quantity");
  input.value = parseInt(input.value) + 1;
}
