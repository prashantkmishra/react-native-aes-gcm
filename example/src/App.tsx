import { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  Switch,
  TouchableOpacity,
  StyleSheet,
  Alert,
  ScrollView,
} from 'react-native';
import { SafeAreaView, SafeAreaProvider } from 'react-native-safe-area-context';
import { encrypt, decrypt } from '@pmishra0/react-native-aes-gcm';

export default function App() {
  const [text, setText] = useState('');
  const [key, setKey] = useState('');
  const [iterations, setIterations] = useState(1000);
  const [saltLength, setSaltLength] = useState(16);
  const [keyLength, setKeyLength] = useState(12);
  const [isEncryptMode, setIsEncryptMode] = useState(true);
  const [result, setResult] = useState('');

  const onActionPress = async () => {
    if (!text || !key) {
      Alert.alert('Error', 'Text and key are required');
      return;
    }
    if (isEncryptMode) {
      const encrypted = await encrypt(text, key, {
        iterationCount: iterations,
      }).catch((e) => {
        console.log('Error Enctyption:: ', e);
        setResult(e.toString());
      });
      if (encrypted) {
        setResult(encrypted);
      }
      console.log('encrypted:: ', encrypted);
      console.log('Input text:: ', text);
      console.log('key:: ', key);
    } else {
      const decrypted = await decrypt(text, key, {
        iterationCount: iterations,
      }).catch((e) => {
        console.log('Error:: ', e);
        setResult(e.toString());
      });
      if (decrypted) {
        setResult(decrypted);
      }
      console.log('DecyptedVal:: ', decrypted);
      console.log('Input text:: ', text);
      console.log('key:: ', key);
    }
  };

  return (
    <SafeAreaProvider>
      <SafeAreaView style={styles.safeArea} edges={['top', 'left', 'right']}>
        <View style={styles.container}>
          <Text style={styles.title}>AES-GCM Crypto Demo</Text>

          <TextInput
            style={styles.input}
            placeholder={isEncryptMode ? 'Plain Text' : 'Cipher Text (Base64)'}
            value={text}
            onChangeText={setText}
            multiline
          />

          <TextInput
            style={styles.input}
            placeholder="Plain key"
            value={key}
            onChangeText={setKey}
          />

          <TextInput
            style={styles.input}
            placeholder="Salt length"
            value={saltLength.toString()}
            onChangeText={(value) => {
              const num = Number.parseInt(value, 10);
              setSaltLength(Number.isNaN(num) ? 0 : num);
            }}
            keyboardType="numeric"
          />

          <TextInput
            style={styles.input}
            placeholder="Key length"
            value={keyLength.toString()}
            onChangeText={(value) => {
              const num = Number.parseInt(value, 10);
              setKeyLength(Number.isNaN(num) ? 0 : num);
            }}
            keyboardType="numeric"
          />

          <TextInput
            style={styles.input}
            placeholder="Iterations count"
            value={iterations.toString()}
            onChangeText={(value) => {
              const num = Number.parseInt(value, 10);
              setIterations(Number.isNaN(num) ? 0 : num);
            }}
            keyboardType="numeric"
          />

          <View style={styles.toggleRow}>
            <Text style={styles.toggleLabel}>
              Mode: {isEncryptMode ? 'Encrypt 🔐' : 'Decrypt 🔓'}
            </Text>

            <Switch value={isEncryptMode} onValueChange={setIsEncryptMode} />
          </View>

          <TouchableOpacity style={styles.button} onPress={onActionPress}>
            <Text style={styles.buttonText}>
              {isEncryptMode ? 'Encrypt' : 'Decrypt'}
            </Text>
          </TouchableOpacity>
          {result?.length > 0 && (
            <>
              <Text style={styles.resultTitle}>Result:</Text>
              <ScrollView
                keyboardShouldPersistTaps="handled"
                contentContainerStyle={styles.scroll}
              >
                <Text style={styles.result}>{result}</Text>
              </ScrollView>
            </>
          )}
        </View>
      </SafeAreaView>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#FFF',
  },
  scroll: {
    flexGrow: 1,
  },
  container: {
    flex: 1,
    padding: 20,
  },
  title: {
    fontSize: 22,
    fontWeight: '600',
    marginBottom: 20,
  },
  resultTitle: {
    fontSize: 22,
    fontWeight: '600',
    marginTop: 20,
  },
  result: {
    fontSize: 16,
    fontWeight: '400',
    marginBottom: 20,
    marginTop: 20,
  },
  input: {
    borderWidth: 1,
    borderColor: '#DDD',
    borderRadius: 10,
    padding: 12,
    marginBottom: 12,
  },
  toggleRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 20,
  },
  toggleLabel: {
    fontSize: 16,
  },
  button: {
    backgroundColor: '#1E88E5',
    padding: 14,
    borderRadius: 12,
    alignItems: 'center',
  },
  buttonText: {
    color: '#FFF',
    fontSize: 16,
    fontWeight: '600',
  },
});
