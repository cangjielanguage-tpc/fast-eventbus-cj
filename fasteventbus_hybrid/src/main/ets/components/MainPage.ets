import { CustomLib } from "libark_interop_api.so";
import {requireCJLib} from 'libark_interop_loader.so'
const cjLib = requireCJLib("libohos_app_cangjie_fastevent_hybrid.so") as CustomLib

export function test_addF64(a:number,b:number){
  cjLib.addF64(a, b)
}




