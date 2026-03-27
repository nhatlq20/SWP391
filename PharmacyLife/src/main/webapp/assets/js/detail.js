function decreaseQty() {
  const input = document.getElementById("quantity");
  let val = parseInt(input.value) || 1;
  if (val > 1) {
    input.value = val - 1;
  } else {
    input.value = 1;
  }
}

function increaseQty() {
  const input = document.getElementById("quantity");
  let val = parseInt(input.value) || 1;
  if (val < 1) val = 1;
  input.value = val + 1;
}
