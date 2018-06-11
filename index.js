import {
  NativeModules,
} from 'react-native';

export const getHex = (options) => new Promise((resolve, reject) => {
  NativeModules.RNPixelColor.getHex(options, (err, color) => {
    if (err) return reject(err);

    resolve(color);
  });
});

export const createTempImage = (path) => NativeModules.RNPixelColor.createTempImage(path);
export default {
  getHex,
  createTempImage,
}
