import { HttpUtils } from '../common/network/HttpUtils'
import ItemData from '../viewmodel/ItemData'
import mainViewModel from '../viewmodel/MainViewModel'
import ListInfo from '../viewmodel/ResponseData/ListInfo'
import { common } from '@kit.AbilityKit';

@Component
export default struct Home {
  @StorageLink('fontSizeOffset') fontSizeOffset: number = 0
  @State httpGridItems: Array<ListInfo> = []
  @State pictureUri: string = ''
  @Link pathStack: NavPathStack
  private swiperController: SwiperController = new SwiperController()
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  private applicationContext = this.context.getApplicationContext()
  private cacheDir = this.applicationContext.filesDir

  async aboutToAppear(): Promise<void> {
    let httpUtil: HttpUtils = new HttpUtils()
    await httpUtil.postHttpRequest().then((value: Array<ListInfo>) => {
      this.httpGridItems = value
    })
    await httpUtil.getHttpRequest(this.cacheDir).then((value: string) => {
      this.pictureUri = value
    })
    httpUtil.destroyHttpRequest()
  }

  build() {
    Column() {
      Text('首页')
        .width('100%')
        .margin({ top: '48vp', bottom: '12vp' })
        .fontWeight(700)
        .fontSize(26 + this.fontSizeOffset)

      Scroll() {
        Column() {
          Swiper(this.swiperController) {
            ForEach(mainViewModel.getSwiperImages(), (img: Resource) => {
              Image(img)
                .width('100%')
                .borderRadius('16vp')
            }, (img: Resource) => JSON.stringify(img.id))
          }
          .autoPlay(true)

          Grid() {
            ForEach(mainViewModel.getFirstGridData(), (item: ItemData, index: number) => {
              GridItem() {
                Column() {
                  Image(item.img)
                    .width('40vp')
                    .height('40vp')
                  Text(item.title)
                    .fontSize(12 + this.fontSizeOffset)
                    .margin({ top: '4vp' })
                }
              }
              .onClick(() => {
                if (index === 4) {
                  this.pathStack.pushPathByName('GoalPage', null)
                  console.info('叭叭啦叭')
                }
              })
            }, (item: ItemData) => JSON.stringify(item))
          }
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .columnsGap('8vp')
          .rowsGap('12vp')
          .backgroundImage($r('app.media.backgroundImage'))
          .backgroundImageSize({ width: '100%', height: '156vp' })
          .margin({ top: '12vp' })
          .padding({ top: '12vp', bottom: '12vp' })
          .height('156vp')
          .backgroundColor(Color.White)
          .borderRadius('16fp')

          Text($r('app.string.home_list'))
            .fontSize('18fp')
            .fontWeight(700)
            .width('100%')
            .margin({ top: '18vp', bottom: '8vp' })
          List() {
            ForEach(this.httpGridItems, (secondItem: ListInfo) => {
              ListItem() {
                Row() {
                  Image(secondItem.indexNavPic)
                    .width('130vp')
                    .height('80vp')
                    .objectFit(ImageFit.TOP_START)
                    .borderRadius('8vp')
                    .margin({ right: '12vp' })

                  Column() {
                    Text(secondItem.activityName)
                      .width('190vp')
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                      .fontSize(16 + this.fontSizeOffset)
                      .fontWeight(FontWeight.Medium)

                    Text(secondItem.theme)
                      .width('190vp')
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(2)
                      .margin({ top: '4vp' })
                      .fontSize(12 + this.fontSizeOffset)
                      .fontColor('#99182431')
                    Row() {
                      Image(this.pictureUri)
                        .width('20vp')
                        .opacity(0.5)
                    }
                    .width('170vp')
                    .margin({ top: '10.5vp' })
                    .justifyContent(FlexAlign.End)
                    .alignItems(VerticalAlign.Bottom)
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .padding({
                  left: '12vp',
                  right: '12vp',
                  top: '12vp',
                  bottom: '12vp'
                })
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .margin({ bottom: '8vp' })
              .borderRadius('16vp')
              .backgroundColor('#ffffff')
              .borderRadius($r('app.float.home_backgroundImage_borderRadius'))
              .align(Alignment.TopStart)
              .width('100%')
            }, (secondItem: ListInfo) => JSON.stringify(secondItem))
          }
          .scrollBar(BarState.Off)
          .width('100%')
          .height(-1)
        }
      }
      .height('660vp')
      .align(Alignment.TopStart)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}