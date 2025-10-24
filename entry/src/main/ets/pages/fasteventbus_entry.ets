import {test_register,EventTs} from '@cangjie-tpc/fasteventbus_hybrid'

export function test_addF64_Entry(){
  //调用仓颉接口
  let a = 1
  let b = 2
  // test_addF64(a,b)
}

export function onEvent(e:EventTs){

}

export function publish(e:EventTs){

}

export function test_register_Entry(){
  //调用胶水层cjLib接口
  let name = "intType"
  test_register(name,onEvent,publish)
}