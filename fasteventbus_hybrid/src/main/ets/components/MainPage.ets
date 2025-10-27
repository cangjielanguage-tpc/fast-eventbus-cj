import { CustomLib } from "libark_interop_api.so";
import {requireCJLib} from 'libark_interop_loader.so'
import {EventTs} from 'libohos_app_cangjie_fastevent_hybrid.so'
const cjLib = requireCJLib("libohos_app_cangjie_fastevent_hybrid.so") as CustomLib

export async function test_register(name:string,sub:(a:EventTs) => void,pub:(a:EventTs) => void):Promise<void>{
  await  cjLib.register(name,sub,pub)
}

export async function test_unregister(name:string,sub:(a:EventTs) => void,pub:(a:EventTs) => void):Promise<void>{
  await  cjLib.unregisterAsync(name)
}

export async function test_publish(name:string,sub:(a:EventTs) => void,pub:(a:EventTs) => void):Promise<void>{
  await  cjLib.publishAsync(name)
}

export function clearContainerByEventTypeName(eventTypeName:string){
  cjLib.clearContainerByEventTypeName(eventTypeName)
}

