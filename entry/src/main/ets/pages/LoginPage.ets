import { promptAction } from '@kit.ArkUI';
import ConnectionUtils from '../common/network/ConnectionUtils';

@Entry
@Component
struct LoginPage {
  @State account: string = '';
  @State password: string = '';
  @State isShowProgress: boolean = false;
  private timeOutId: number = -1;
  pathStack: NavPathStack = new NavPathStack();

  @Builder
  imageButton(src: Resource) {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      Image(src)
    }
    .height('48vp')
    .width('48vp')
    .backgroundColor('#F1F3F5')
  }

  login(result: boolean): void {
    if (this.account === '' || this.password === '') {
        promptAction.showToast({
          message: '账号密码不能为空！'
        })
    } else {
      this.isShowProgress = true;
      if (this.timeOutId === -1) {
        this.timeOutId = setTimeout(() => {
          this.isShowProgress = false;
          this.timeOutId = -1;
          if (result) {
            this.pathStack.pushPathByName('MainPage', null)
          } else {
            this.getUIContext().getPromptAction().showToast({
              message: '无网络连接，无法登录'
            });
          }
        }, 2000);
      }
    }
  }

  aboutToDisappear() {
    clearTimeout(this.timeOutId);
    this.timeOutId = -1;
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Image($r('app.media.logo'))
          .width('78vp')
          .height('78vp')
          .margin({ top: '150vp', bottom: '8vp' })
        Text('登录界面')
          .fontSize('24fp')
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
        Text('登录账号以使用更多服务')
          .fontSize('16fp')
          .fontColor('#99182431')
          .margin({ bottom: '30vp', top: '8vp' })
        TextInput({ placeholder: '账号' })
          .maxLength(11)
          .type(InputType.Number)
          .inputStyle()
          .onChange((value: string) => {
            this.account = value;
          })
        Line()
          .lineStyle()
        TextInput({ placeholder: '密码' })
          .maxLength(8)
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value;
          })
          .inputStyle()
        Line()
          .lineStyle()
        Row() {
          Text('短信验证码登录')
            .blueTextStyle()
          Text('忘记密码')
            .blueTextStyle()
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: '8vp' })

        Button('登录')
          .width('90%')
          .height('40vp')
          .fontSize('16fp')
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#007DFF')
          .margin({ top: '48vp', bottom: '12vp' })
          .onClick(() => {
            this.login(ConnectionUtils.isNetworkConnected());
          })
        Text('注册账号')
          .fontColor('#007DFF')
          .fontSize('16fp')
          .fontWeight(FontWeight.Medium)
        if (this.isShowProgress) {
          LoadingProgress()
            .color('#182431')
            .width('30vp')
            .height('30vp')
            .margin({ top: '20vp' })
        }

        Blank()
        Text('其他登录方式')
          .fontColor('#838D97')
          .fontSize('12fp')
          .fontWeight(FontWeight.Medium)
          .margin({ top: '50vp', bottom: '12vp' })
        Row({ space: '44vp' }) {
          this.imageButton($r('app.media.login_method1'))
          this.imageButton($r('app.media.login_method2'))
          this.imageButton($r('app.media.login_method3'))
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: '12vp', right: '12vp', bottom: '24vp' })
    }
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}

@Extend(TextInput)
function inputStyle() {
  .placeholderColor('#99182431')
  .height('45vp')
  .fontSize('18fp')
  .backgroundColor('#F1F3F5')
  .width('100%')
  .margin({ top: '12vp' })
}

@Extend(Line)
function lineStyle() {
  .width('100%')
  .height('1vp')
  .backgroundColor('#33182431')
}

@Extend(Text)
function blueTextStyle() {
  .fontColor('#007DFF')
  .fontSize('14fp')
  .fontWeight(FontWeight.Medium)
}