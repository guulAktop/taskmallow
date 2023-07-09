class AppConstants {
  static final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  static final RegExp usernameRegex = RegExp(r'^(?=[a-zA-Z0-9._]{3,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');
  static const double iconSplashRadius = 22;

  static const String privacyPolicyEN =
      """This Privacy Policy outlines the policies regarding the collection, use, and sharing of personal information of users (referred to as "you" or "user") of the TaskMallow mobile application (referred to as the "app" or "we"). By using the TaskMallow application, you agree to this Privacy Policy.

Collected Information
1.1. Registration Information: When registering for the TaskMallow application, we may collect certain basic identification information, such as your name, email address, and other required details.

1.2. Contact Information: When you send us a message through the communication forms within the app, we may collect your contact information, such as your name, email address, or phone number.

1.3. Usage Information: While using the app, we may automatically collect usage information, such as the progress status of your tasks, interactions with team members, and shared files.

1.4. Device Information: When using the app, we may collect technical device information, such as the type of device, operating system, and browser details.

1.5. Cookies: We may use cookies within the app. Cookies are used to manage user sessions, remember preferences, and enhance app performance. You can adjust your browser settings to accept or reject cookies. However, disabling cookies may impact the functionality of certain features within the app.

Use of Information
2.1. We may use the collected personal information for the following purposes:

To provide and manage the app services.
To respond to user inquiries and provide support.
To send relevant notifications and updates.
To conduct improvement efforts and enhance user experience.
To perform statistical analysis and measure app performance.
2.2. Unless required by law or for legal processes, resolving disputes, or legal defense, we will not share your personal information with third parties.

Data Security
3.1. TaskMallow takes appropriate security measures to protect your personal information. However, please note that no transmission over the internet or storage method is 100% secure.

3.2. You are responsible for the security of your login credentials, such as username and password. Do not share these credentials with others, and it is recommended to use a strong password.

Other Websites and Applications
4.1. The TaskMallow app may contain links to other websites or applications. We are not responsible for the privacy policies and practices of those accessed websites or applications.

Updates to the Privacy Policy
5.1. This Privacy Policy may be updated from time to time. The updated Privacy Policy will be effective as of the date of publication within the app. It is recommended to regularly review the Privacy Policy to stay informed of any changes.

Contact
6.1. If you have any questions or concerns regarding the Privacy Policy, please feel free to contact us.

taskmallow@gmail.com

Last Updated: [09.07.2023]""";

  static const String privacyPolicyTR =
      """Bu Gizlilik Politikası, TaskMallow mobil uygulamasının (bundan sonra "uygulama" veya "biz" olarak anılacaktır) kullanıcılarının (bundan sonra "siz" veya "kullanıcı" olarak anılacaktır) kişisel bilgilerinin toplanması, kullanılması ve paylaşılması ile ilgili politikaları açıklamaktadır. TaskMallow uygulamasını kullanarak, bu Gizlilik Politikası'nı kabul etmiş olursunuz.

Toplanan Bilgiler
1.1. Kayıt Bilgileri: TaskMallow uygulamasına kayıt olurken, adınız, e-posta adresiniz ve diğer gerekli bilgiler gibi bazı temel kimlik bilgilerinizi toplayabiliriz.

1.2. İletişim Bilgileri: Uygulama içindeki iletişim formlarını kullanarak bize mesaj gönderdiğinizde, adınız, e-posta adresiniz veya telefon numaranız gibi iletişim bilgilerinizi toplayabiliriz.

1.3. Kullanım Bilgileri: Uygulamayı kullanırken, görevlerinizin ilerleme durumu, ekip üyeleriyle olan etkileşimleriniz, paylaştığınız dosyalar gibi kullanım bilgilerini otomatik olarak toplayabiliriz.

1.4. Cihaz Bilgileri: Uygulamayı kullanırken, cihazınızın türü, işletim sistemi, tarayıcı bilgileri gibi teknik cihaz bilgilerini toplayabiliriz.

1.5. Çerezler: Uygulama içinde çerezleri kullanabiliriz. Çerezler, kullanıcı oturumlarını yönetmek, tercihleri hatırlamak ve uygulama performansını iyileştirmek amacıyla kullanılır. Çerezleri kabul etmek veya reddetmek için tarayıcı ayarlarınızı düzenleyebilirsiniz. Ancak, bazı durumlarda çerezlerin devre dışı bırakılması uygulamanın bazı özelliklerinin düzgün çalışmasını engelleyebilir.

Bilgilerin Kullanımı
2.1. Toplanan kişisel bilgilerinizi, aşağıdaki amaçlarla kullanabiliriz:

Uygulama hizmetlerini sunmak ve yönetmek.
Kullanıcı taleplerini yanıtlamak ve destek sağlamak.
İlgili bildirimleri göndermek ve güncellemeler sağlamak.
İyileştirme çalışmaları yapmak ve kullanıcı deneyimini geliştirmek.
İstatistiksel analizler yapmak ve uygulamanın performansını ölçmek.
2.2. Kişisel bilgileriniz, yasal gerekliliklerin yerine getirilmesi veya yasal işlemlere uyma, hukuki savunma veya anlaşmazlıkların çözülmesi gibi durumlar dışında üçüncü taraflarla paylaşılmaz.

Veri Güvenliği
3.1. TaskMallow, kişisel bilgilerinizi korumak için uygun güvenlik önlemleri alır. Ancak, internet üzerinden iletişimin her zaman tamamen güvenli olmadığını ve herhangi bir güvenlik önleminin mutlak olmadığını unutmayın.

3.2. Kullanıcı adı ve şifreniz gibi giriş bilgilerinizin güvenliğinden siz sorumlusunuz. Bu bilgileri başkalarıyla paylaşmamalısınız ve güçlü bir şifre kullanmanız önerilir.

Diğer Web Siteleri ve Uygulamalar
4.1. TaskMallow uygulaması, diğer web sitelerine veya uygulamalara bağlantılar içerebilir. Bu bağlantılar üzerinden erişilen web sitelerinin veya uygulamaların gizlilik politikaları ve uygulamalarından biz sorumlu değiliz.

Gizlilik Politikası Güncellemeleri
5.1. Bu Gizlilik Politikası, zaman zaman güncellenebilir. Güncellenmiş Gizlilik Politikası, uygulamada yayınlandığı tarihte yürürlüğe girecektir. Yenilikleri takip etmek için düzenli olarak Gizlilik Politikası'nı kontrol etmeniz önerilir.

İletişim
6.1. Gizlilik Politikası ile ilgili herhangi bir sorunuz veya endişeniz varsa, lütfen bizimle iletişime geçmekten çekinmeyin.

taskmallow@gmail.com

Son güncelleme: [09.07.2023]""";
}
