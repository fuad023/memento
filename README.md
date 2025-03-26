# Memento - Anonymous Chat with a Single Host  

### **🚀 What is Memento?**  
Traditional social media MNCs have failed to uphold user trust by exploiting smart devices for surveillance. To tackle this, I built my own chat app—**Memento**.  

In this app, **you can send me messages anonymously**. I am the **only host** (meaning I am the only one who receives messages). I intentionally did **not** allow others to become hosts in the web-app I’m deploying because that would mean storing their private conversations in my database. That’s exactly what big corporations do—collect user data. I don’t want that power, so I designed Memento differently.  

However, **if you want to run your own version of Memento where you can be the host**, you can clone this repository, add your own backend credentials, and deploy it separately. This means your version will be completely independent from mine.

---

### **🔑 Features**  
✅ **Send me messages anonymously** (duhh).  
✅ **No account required** (anonymity is the core principle).  
✅ **You remain anonymous** (unless *you* decide otherwise).  
✅ **Each conversation gets a unique CODE** to continue from where you left off (*find it in the drawer header, tap to copy it*).  
✅ **Full control over your data**—you can wipe out everything anytime.  

---

### **🛠️ How It Works**  
1. Open Memento.  
2. Send a message without creating an account.  
3. Receive a unique CODE to continue the conversation later.  
4. If you ever want to *terminate* all your data here, you can do so with a tap.  

---

### **🛠️ Tech Stack**  
- **Framework:** Flutter  
- **Backend:** Firebase  

---

### **🛠️ Setting Up Your Own Host Version**  
If you want to modify Memento and become a host yourself, follow these steps:  

#### **1️⃣ Clone the Repo**  
```sh
git clone https://github.com/fuad023/memento.git
cd memento
```

#### **2️⃣ Provide Your Own Credentials**  
This project gitignores a class called Credential, which contains static data like backend API keys.
To set up your own host version, create a Credential class inside the lib/ directory and provide your own backend details.
```sh
class Credential {
  static String get WEB_API_KEY => 'your-api-key-here';
  static String get WEB_APP_ID => 'your-api-app-id-here';
  static String get WEB_AUTH_DOMAIN => 'your-auth-domain';

  static String get PROVIDER => 'just-write-something';
  static String get HOST_EMAIL => 'provide-the-one-you-setup-on-firebase-auth';
  static String get HOST_UID => 'create-one-from-firebase-auth';
  static String get PASSWORD => 'just-write-something';
}
```
🚨 **Note:** The above is not a complete implementaion. Your actual one may vary depending on your backend setup.

#### **3️⃣ Install Dependencies**
```sh
flutter pub get
```
#### **4️⃣ Run the App**
```sh
flutter run
```  

---

### **📌 Disclaimer**
Use it responsibly. I do not store personal data beyond what’s necessary for functionality. If you set up your own host version, you are fully responsible for handling user data securely.  