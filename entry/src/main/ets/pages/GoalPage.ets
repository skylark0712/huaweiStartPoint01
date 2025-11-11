import { hilog } from '@kit.PerformanceAnalysisKit';
import RDBStoreUtil from '../common/database/RDBStoreUtil';
import { GoalItem } from '../viewmodel/GoalItem';

const TAG = 'GoalPage';

@Builder
export function GoalPageBuilder() {
  GoalPage()
}

@Component
export struct GoalPage {
  @State plansSet: Array<GoalItem> = [];
  @State plan: GoalItem = new GoalItem(0, '', '', 0, '');
  @State durationSelectOptions: Array<SelectOption> = [];
  @State durationSet: Array<number> = [];
  @State currentDuration: number | undefined = undefined;
  @State currentStatus: boolean | undefined = undefined;
  @State isUpdateShow: boolean = false;
  @State isInsetShow: boolean = false;
  @State currentNumber: number = 0;
  @State currentPlan: GoalItem = new GoalItem(0, '', '', 0, '');
  @State duration: number = 0;
  @State status: boolean = false;
  @State addSportID: number = 0;
  @State addDuration: number = 0;
  @State addStatus: boolean = false;

  @Builder
  updateBindSheet(planData: GoalItem) {
    Column() {
      Row() {
        Text('运动名')
          .font({
            size: '16fp',
            weight: 500
          })
          .opacity(0.9)
        Select([
          { value: '晨跑' },
          { value: '瑜伽' },
          { value: '游泳' }
        ])
          .value('晨跑')
          .value(planData.sportName)
          .focusable(false)
          .width('150vp')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('90%')
      .margin({
        top: '15vp',
        bottom: '15vp'
      })

      Row() {
        Text('运动时长（分钟）')
          .font({
            size: '16fp',
            weight: 400
          })
          .opacity(0.9)
        TextInput({ text: planData.duration.toString() })
          .onChange((data: string) => {
            this.duration = Number.parseInt(data);
          })
          .width('150vp')
      }
      .width('90%')
      .margin({ bottom: '15vp' })
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text('运动完成状态')
          .font({
            size: '16fp',
            weight: 400
          })
          .opacity(0.9)
        Select([
          { value: '已完成' },
          { value: '未完成' }
        ])
          .width('150vp')
          .value(planData.status)
          .onSelect((index: number) => {
            if (index === 0) {
              this.status = true;
            } else {
              this.status = false;
            }
          })
      }
      .width('90%')
      .margin({ bottom: '15vp' })
      .justifyContent(FlexAlign.SpaceBetween)

      Button('提交')
        .width('288vp')
        .onClick(async () => {
          await RDBStoreUtil.updatePlan(planData.id, this.duration, this.status);
          await RDBStoreUtil.queryAllPlans().then((value) => {
            this.plansSet = value;
          });
          this.refreshSelectOption();
          this.isUpdateShow = false;
        })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  @Builder
  insertBindSheet() {
    Column() {
      Row() {
        Text('运动名')
          .font({
            size: '16fp',
            weight: 500
          })
          .opacity(0.9)
        Select([
          { value: '晨跑' },
          { value: '瑜伽' },
          { value: '游泳' }
        ])
          .value('晨跑')
          .onSelect((index: number) => {
            this.addSportID = index;
          })
          .width('170vp')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('90%')
      .margin({
        top: '15vp',
        bottom: '15vp'
      })

      Row() {
        Text('运动时长（分钟）')
          .font({
            size: '16fp',
            weight: 400
          })
          .opacity(0.9)
        TextInput({ placeholder: '请输入运动时长' })
          .onChange((data: string) => {
            this.addDuration = Number.parseInt(data);
          })
          .width('170vp')
      }
      .width('90%')
      .margin({ bottom: '15vp' })
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text('运动完成状态')
          .font({
            size: '16fp',
            weight: 400
          })
          .opacity(0.9)
        Select([
          { value: '已完成' },
          { value: '未完成' }
        ])
          .value('未完成')
          .onSelect((index: number) => {
            if (index === 0) {
              this.addStatus = true;
            } else {
              this.addStatus = false;
            }
          })
          .width('170vp')
      }
      .width('90%')
      .margin({ bottom: '15vp' })
      .justifyContent(FlexAlign.SpaceBetween)

      Button('提交')
        .width('288vp')
        .onClick(async () => {
          await RDBStoreUtil.insertPlan(this.addSportID, this.addDuration, this.addStatus);
          await RDBStoreUtil.queryAllPlans().then((value) => {
            this.plansSet = value;
          });
          this.refreshSelectOption();
          this.isInsetShow = false;
        })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  async aboutToAppear(): Promise<void> {
    RDBStoreUtil.createSportTable();
    RDBStoreUtil.initSportTable();
    RDBStoreUtil.createPlanTable();
    await RDBStoreUtil.queryAllPlans().then((value) => {
      this.plansSet = value;
    });
    this.refreshSelectOption();
  }

  async refreshSelectOption() {
    await RDBStoreUtil.queryAllPlansDuration().then((value) => {
      this.durationSet = value;
    });
    this.durationSelectOptions = [{ value: '任意' }];
    for (let i = 0; i < this.durationSet.length; i++) {
      this.durationSelectOptions.push({ value: this.durationSet[i] + 'min' });
    }
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Text('我的目标')
            .width('100%')
            .font({
              size: '30fp',
              weight: 700
            })
            .margin({
              top: '48vp',
              bottom: '32vp'
            })
          Row() {
            Select(this.durationSelectOptions)
              .onSelect((index: number) => {
                if (index === 0) {
                  this.currentDuration = undefined;
                } else {
                  this.currentDuration = this.durationSet[index-1];
                }
              })
              .value('时长')
              .margin({ right: '25vp' })
            Select([{ value: '任意' },
              { value: '已完成' },
              { value: '未完成' }])
              .onSelect((index: number) => {
                if (index === 0) {
                  this.currentStatus = undefined;
                } else if (index === 1) {
                  this.currentStatus = true;
                } else {
                  this.currentStatus = false;
                }
              })
              .value('状态')
              .margin({ right: '25vp' })
            Image($r('app.media.reset'))
              .width(40)
              .onClick(async () => {
                await RDBStoreUtil.queryAllPlans().then((value) => {
                  this.plansSet = value;
                });
              })
              .margin({ right: '16vp' })
            Image($r('app.media.sift'))
              .width(40)
              .onClick(async () => {
                await RDBStoreUtil.conditionalPlansQuery(this.currentDuration, this.currentStatus).then((value) => {
                  this.plansSet = value;
                });
              })
              .margin({ right: '16vp' })
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          List() {
            ForEach(this.plansSet, (item: GoalItem, index: number) => {
              ListItem() {
                Row() {
                  Column() {
                    Text(item.sportName)
                      .font({
                        size: '16fp',
                        weight: 500
                      })
                      .opacity(0.9)
                    Text(item.type)
                      .font({
                        size: '14fp',
                        weight: 400
                      })
                      .opacity(0.6)
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: '16vp' })

                  Text(item.duration + 'min')
                    .font({
                      size: '14vp',
                      weight: 400
                    })
                    .opacity(0.6)
                  Text(item.status)
                    .font({
                      size: '14vp',
                      weight: 400
                    })
                    .opacity(0.6)
                  Image($r('app.media.edit'))
                    .width('40vp')
                    .onClick(() => {
                      this.currentNumber = index;
                      this.currentPlan = item;
                      this.isUpdateShow = true;
                    })
                  Image($r('app.media.delete'))
                    .width('40vp')
                    .margin({ right: '16vp' })
                    .onClick(() => {
                      this.getUIContext().showAlertDialog(
                        {
                          message: '你确定要删除该计划吗？',
                          autoCancel: true,
                          alignment: DialogAlignment.Bottom,
                          gridCount: 4,
                          offset: { dx: 0, dy: -20 },
                          primaryButton: {
                            value: '取消',
                            action: () => {
                              hilog.info(0x0000, TAG, 'Callback when the first button is clicked');
                            }
                          },
                          secondaryButton: {
                            enabled: true,
                            defaultFocus: true,
                            style: DialogButtonStyle.HIGHLIGHT,
                            value: '删除',
                            action: async () => {
                              await RDBStoreUtil.deletePlan(item.id);
                              this.refreshSelectOption();
                              await RDBStoreUtil.queryAllPlans().then((value) => {
                                this.plansSet = value;
                              });
                            }
                          },
                          cancel: () => {
                            hilog.info(0x0000, TAG, 'Closed callbacks');
                          },
                          onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
                            if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
                              dismissDialogAction.dismiss();
                            }
                            if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
                              dismissDialogAction.dismiss();
                            }
                          }
                        }
                      )

                    })
                }
                .width('100%')
                .height('100%')
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .width('100%')
              .height('60vp')
            }, (item: GoalItem) => JSON.stringify(item))
          }
          .width('100%')
          .divider({
            strokeWidth: 1,
            color: '#1a000000',
            startMargin: 16,
            endMargin: 16
          })
          .bindSheet(this.isUpdateShow, this.updateBindSheet(this.currentPlan), {
            height: '320vp',
            title: { title: '运动完成情况' },
            onDisappear: () => {
              this.isUpdateShow = false;
            }
          })
        }

        Button('新增计划')
          .width('100%')
          .margin({ bottom: '32vp' })
          .onClick(() => {
            this.isInsetShow = true;
          })
          .bindSheet(this.isInsetShow, this.insertBindSheet(), {
            height: '320vp',
            title: { title: '新增计划' },
            onDisappear: () => {
              this.isInsetShow = false;
            }
          })
      }
      .padding({
        left: '12vp',
        right: '12vp'
      })
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .backgroundColor('#F1F3F5')
    .hideTitleBar(true)
  }
}