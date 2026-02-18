# react-native-aes-gcm

AES-GCM encryption/decryption for React Native

## Installation

```sh
npm install react-native-aes-gcm
```

## Usage


```js
import { encrypt, decrypt } from 'react-native-aes-gcm';

// ...

const encrypted = await encrypt(text, key, iterations).catch((e) => {
        console.log('Error Enctyption:: ', e);
        
      });

const decrypted = await decrypt(text, key, iterations).catch((e) => {
        console.log('Error:: ', e);
        
      });
     
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
