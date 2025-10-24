import { CustomLib } from "libark_interop_api.so";
import {requireCJLib} from 'libark_interop_loader.so'
import {EventTs} from 'libohos_app_cangjie_fastevent_hybrid.so'
const cjLib = requireCJLib("libohos_app_cangjie_fastevent_hybrid.so") as CustomLib

export function test_register(name:string,sub:(a:EventTs) => void,pub:(a:EventTs) => void){
  cjLib.arktsFuncToCj(name,sub,pub)
}

