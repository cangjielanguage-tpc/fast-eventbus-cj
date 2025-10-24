export declare class EventTs {
    constructor (evevtTypeName: string, subscriber: (funcArg0: EventTs) => void, publisher: (funcArg0: EventTs) => void)
}

export declare function arktsFuncToCj(name: string, sub: (funcArg0: EventTs) => void, pub: (funcArg0: EventTs) => void): void
