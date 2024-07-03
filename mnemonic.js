const bip39 = require("bip39");
const mnemonic = "pen rally blur record bench gesture region lyrics click census voyage dream";
if (bip39.validateMnemonic(mnemonic)) {
  console.log("valid mnemoniv");
} else {
  console.log("invalid mnemonic");
}
const mnemonic_ = bip39.generateMnemonic();
console.log(mnemonic_);
