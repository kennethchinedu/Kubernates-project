import CryptoJS from "crypto-js";
import appConfig from "./appConfig";

const secretPass = appConfig.APP_CRYPTO_JS_KEY;

export const encryptData = (data: any): string => {
  const encryptedData = CryptoJS.AES.encrypt(
    JSON.stringify(data),
    secretPass,
  ).toString();

  return encryptedData;

  // UNCOMMENT NEXT LINE TO OBSERVE ENCRYPETED STORES FOR TEST PURPOSES ONLY
  // return JSON.stringify(data);
};

export const decryptData = (data: string) => {
  const bytes = CryptoJS.AES.decrypt(data, secretPass);
  const decryptedData = JSON.parse(bytes.toString(CryptoJS.enc.Utf8));
  return decryptedData;

  // UNCOMMENT NEXT LINE TO OBSERVE ENCRYPETED STORES FOR TEST PURPOSES ONLY
  // return JSON.parse(data);
};
