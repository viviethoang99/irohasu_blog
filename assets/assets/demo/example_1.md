# Lời tựa
Mặc dù hiện nay đã có nhiều flutter package hỗ trợ việc chia môi trường cho anh em sử dụng, nhưng Quokka vẫn muốn tự thân tự code và cấu hình. Các công cụ sinh ra để hỗ trợ năng suất của DEV, nhưng cũng đừng nên phụ thuộc vào nó quá đúng không nào?!
# Bài viết: Sử dụng Flutter flavors để thiết lập môi trường DEV và LIVE - Phần 2 - iOS
Nguồn: [https://www.chwe.at/2020/10/flutter-flavors/](https://www.chwe.at/2020/10/flutter-flavors/)
Ở [Phần một](https://viblo.asia/p/flutter-cai-dat-flavors-trong-flutter-phan-1-danh-cho-android-YWOZrGWElQ0), Quokka đã cấu hình và lấy thành công giá trị flavor từ Android. Trong phần này, Quokka tiếp tục hướng dẫn mọi người thiết lập trên nền tảng iOS nhé! 😁
# Thiết lập flavors cho iOS
Việc thiết lập Flavors cho iOS phức tạp hơn Android một chút. Để làm được điều đó, chúng ta phải có XCode để thiết lập và MacOS để chạy XCode (nếu ai chưa có thì mua nhé 😁).
Vẫn sử dụng project ở phần 1, Quokka tiến hành thử build ứng dụng với 1 giá trị flavor cho iOS, lúc này trên console của IDE sẽ báo lỗi:

```dart
flutter build ios --flavor dev

The Xcode project does not define custom schemes. You cannot use the --flavor option.
```

Đúng như nội dung mà lỗi trên miêu tả, để có thể chạy script trên dành cho iOS, chúng ta phải sử dụng tính năng "custom schemes" trên XCode để thiết lập các giá trị flavors. Việc cài đặt này có nhiều bước, Quokka sẽ hướng dẫn mọi người từng bước một, mọi người chú ý làm theo nhé!
## Tạo cấu hình build tùy chỉnh cho các flavors
Quokka mở thư mục `ios` bằng XCode và bắt đầu tạo các thiết lập tùy chỉnh:
* Đảm bảo **"Runner"** được chọn trong XCode.
* Trong cửa sổ chính, chọn nút "Runner" bên dưới "PROJECT" (KHÔNG phải bên dưới TARGETS)
* Chọn tab “Info”
* Trong phần “Configurations”, ta làm như sau:
	* Đổi tên “Debug” thành “Debug-dev”
	* Đổi tên “Release” thành “Release-dev”
	* Đổi tên “Profile” thành “Profile-dev”
	* Duplicate “Debug-dev” và đổi tên thành “Debug-live”
	* Duplicate “Release-dev” và đổi tên thành “Release-live”
	* Duplicate “Profile-dev” và đổi tên nó thành “Profile-live” Việc thiết lập các thông số phía trên sẽ tạo các cấu hình “Debug”, “Release” và “Profile” tương ứng cho từng flavor.

![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_configurations.png)
## Gán cấu hình build cho các custom schemes
Bây giờ Quokka có thể thiết lập các “custom schemes” bằng cách thực hiện như sau:
* Đảm bảo rằng "Runner" được chọn trong XCode
* Chọn “Product -> Scheme -> Manage Schemes…” trên thanh công cụ chính.
* Thiết lập "dev" scheme:
	* Chọn "Runner" scheme, nhấp vào biểu tượng cài đặt ở trên cùng bên trái và chọn "Duplicate"
	* Đổi tên scheme thành “dev”
	* Đảm bảo rằng “Shared” được chọn
	* Đóng hộp thoại
* Thiết lập "live" scheme:
	* Chọn lại "Runner" scheme, nhấp vào biểu tượng cài đặt ở trên cùng bên trái và chọn "Duplicate"
	* Đổi tên scheme thành "live"
	* Đối với mỗi phần (“Run”, “Test”, “Profile”, “Analyze”, “Archive”) ở bên trái, hãy thay đổi cấu hình build phiên bản “-live” tương ứng.
	* Đảm bảo rằng “Shared” được chọn
	* Đóng hộp thoại

![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_live_scheme.png)
Quay lại danh sách “schemes”, bây giờ ta có thể xóa scheme “Runner” hiện có. Sau khi xóa danh sách schemes sẽ trông như thế này:

![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_schemes.png)
## Tạo method channel cho iOS
Bây giờ Quokka thử build ứng dụng nhưng nó không thành công với lỗi sau:

```shell
[VERBOSE-2:ui_dart_state.cc(177)] Unhandled Exception: MissingPluginException(No implementation found for method getFlavor on channel flavor)
```

Nguyên nhân là bởi vì Quokka chưa triển khai method channel mà Flutter sử dụng để lấy flavor từ iOS. Để thêm điều này, Quokka cần thêm vài dòng code "ma thuật" vào `application()` - một function ở trong file `Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window.rootViewController as! FlutterViewController

    let flavorChannel = FlutterMethodChannel(
        name: "flavor",
        binaryMessenger: controller.binaryMessenger)

    flavorChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // Note: this method is invoked on the UI thread
        let flavor = Bundle.main.infoDictionary?["App - Flavor"]
        result(flavor)
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}`
`
```

Với các dòng code "ma thuật" Quokka viết ở phía trên, nó sẽ tạo ra một method channel để lấy flavor từ `Bundle.main.infoDictionary` với key là `App - Flavor` (Key này là do mình đặt, Quokka sẽ khai báo nó trong file Info.plist ở mục tiếp theo).
## Thiết lập giá trị Flavor cho từng scheme
`App - Flavor` như đã đề cập, nó là một key tùy chỉnh mà Quokka phải khai báo trong file Info.plist. Mở file `Runner/Info.plist` trong XCode và thêm một hàng mới với các giá trị sau:
* Key: `App - Flavor`
* Type: `String`
* Value: `$(APP_FLAVOR)`
Bây giờ Quokka đã có key, nhưng từ key đó Quokka vẫn chưa thể lấy giá trị flavor cụ thể thực tế cho từng scheme. Để có được nó, Quokka tiếp tục thiết lập như sau:
* Chọn nút "Runner" trong cấu trúc dự án XCode
* Chọn “Runner” bên dưới TARGET
* Chọn tab "Build settings"
* Nhấp vào dấu + để thêm cài đặt User-defined
* Đặt tên: `APP_FLAVOR`
* Nhấp vào mũi tên nhỏ ở bên trái của hàng đang chọn và thêm giá trị flavor tương ứng cho từng cấu hình build:
	* Debug-dev: `dev`
	* Debug-live: `live`
	* Profile-dev: `dev`
	* Profile-live: `live`
	* Release-dev: `dev`
	* Release-live: `live` Khi hoàn thành, ta sẽ được như thế này:

![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_flavor_setting.png)
## Chạy ứng dụng iOS
Bây giờ chúng ta có thể chọn “dev” scheme trong thanh điều hướng trên cùng của XCode và chạy ứng dụng.
_LƯU Ý: Nếu bạn gặp lỗi lạ lúc buildtừ XCode, hãy thử chuyển đổi giữa các scheme dev/live hoặc thử khởi động lại XCode hoặc chạy ứng dụng iOS từ Android Studio._
Lúc chạy thành công, ta sẽ thấy đầu ra console tương tự như đối với ứng dụng Android ở Phần 1:

`2020-10-03 14:44:05.525493+0200 Runner[26055:336596] flutter: STARTED WITH FLAVOR dev
2020-10-03 14:44:05.526672+0200 Runner[26055:336596] flutter: API URL https://dev.flutter-flavors.chwe.at
`
Quá ngon! Cuối cùng Quokka cũng đã thiết lập được các flavor của mình cho iOS! 🤩
## Đặt bundle id và tên ứng dụng cho mỗi flavor trong iOS
Hiện tại tên ứng dụng trên iPhone vẫn là “flutter_flavors” và khi chạy cả hai phiên bản (dev/live), ta vẫn chỉ có một ứng dụng trên điện thoại của mình:

![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_wrong_appname.png)
Ở phần 1, đối với Android, Quokka đã đặt các giá trị app name và app id trong file `build.gradle`. Bây giờ, Quokka sẽ làm điều tương tự cho iOS nhưng cách thiết lập sẽ khác Android.
### Đặt bundle id cho từng Flavor
Mở file `Info.plist` Quokka thấy một khóa có tên `Bundle identifier` chứa giá trị động `$(PRODUCT_BUNDLE_IDENTIFIER)`. Ta sẽ cần sửa đổi giá trị của khóa này trong Build settings:
* 
	Trong XCode, chọn "Runner" trong cấu trúc dự án XCode
* 
	Chọn “Runner” bên dưới TARGET
* 
	Chuyển đến tab "Build Settings"
* 
	Trong phần “Packaging”, tìm khóa “Product Bundle Identifier”
* 
	Nhấp vào mũi tên nhỏ bên trái
* 
	Đặt giá trị cho từng cấu hình build:
	* Debug-dev: `at.chwe.flutterflavors.dev`
	* Debug-live: `at.chwe.flutterflavors`
	* Profile-dev: `at.chwe.flutterflavors.dev`
	* Profile-live: `at.chwe.flutterflavors`
	* Release-dev: `at.chwe.flutterflavors.dev`
	* Release-live: `at.chwe.flutterflavors`
	![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_bundle_id.png)
	### Đặt tên ứng dụng cho từng FlavorĐể có tên hiển thị riêng cho mỗi flavor, hãy làm như sau:
* Trong XCode, chọn "Runner" trong cấu trúc dự án XCode
* Chọn “Runner” bên dưới TARGET
* Chọn tab “Info”
* Thay đổi giá trị của khóa `Bundle name` thành `$(APP_NAME)`.
* Chuyển đến tab "Build Settings”
* Thêm cài đặt User-Defined
* Đặt tên là `APP_NAME`
* Mở rộng nút `APP_NAME` bằng cách nhấp vào mũi tên nhỏ ở bên trái của nút.
* Đặt giá trị cho mỗi cấu hình bản dựng:
	* Debug-dev: `DEV Flutter Flavors`
	* Debug-live: `Flutter Flavors`
	* Profile-dev: `DEV Flutter Flavors`
	* Profile-live:`Flutter Flavors`
	* Release-dev: `DEV Flutter Flavors`
	* Release-live: `Flutter Flavors`

![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_bundle_id.png)
## Chạy lại ứng dụng với dev/live flavor
Xóa ứng dụng “flutter_flavors” hiện có khỏi iPhone của bạn và chạy lại ứng dụng đó với từng flavor. Bây giờ ta sẽ có cả hai ứng dụng có tên khác nhau trên điện thoại của mình:

![](https://www.chwe.at/uploads/2020/flutter_flavors_ios_app_icons.png)
## Thêm cài đặt flavor cụ thể của riêng bạn
Nếu mọi người cần cài đặt dành riêng cho các flavor khác, ta phải xem xét liệu đó có phải là cài đặt dành riêng cho từng nền tảng hay không, nó cần được tích hợp trực tiếp vào thư mục `android` và `ios` hay đó chỉ là cài đặt trong code Flutter.
Đối với cài đặt dành riêng cho nền tảng Android/iOS, hướng dẫn của Quokka ở trên để đặt tên ứng dụng và id sẽ hữu ích.
Đối với các cài đặt chỉ cần thiết lập trong code Flutter, chỉ cần thêm chúng vào class `FlavorSettings` mà Quokka đã tạo ở Phần 1.
# Thu hoạch
Bây giờ Quokka đã thiết lập dự án Flutter của mình chạy theo nhiều flavors. Quokka sử dụng những flavor đó để phân tách môi trường ứng dụng của mình (DEV & LIVE). Bằng cách này, Quokka không cần phải comment code theo cách thủ công để chuyển đổi URL API hoặc bất kỳ cài đặt nào khác. Quokka cũng có thể cài đặt cả hai phiên bản trên cùng một điện thoại, điều này giúp việc phát triển dễ dàng hơn nhiều vì ta có thể phát triển trên phiên bản DEV trong khi chúng ta vẫn có thể sử dụng phiên bản LIVE đã được triển khai trên store.
Ngoài ra, việc chia môi trường bằng flavor sẽ hữu dụng trong các công đoạn thiết lập CI/CD. Ví dụ: Khi merge code vào nhánh dev hoặc master hệ thống sẽ tự động distribute ra phiên bản tương ứng để gửi đến các thành viên trong nhóm phát triển. Nếu có thời gian, Quokka sẽ viết thêm các bài viết hướng dẫn mọi người tạo CI/CD trong Flutter. Hy vọng mọi người sẽ theo dõi.
Quokka cảm ơn tất cả anh em ! ❤️
