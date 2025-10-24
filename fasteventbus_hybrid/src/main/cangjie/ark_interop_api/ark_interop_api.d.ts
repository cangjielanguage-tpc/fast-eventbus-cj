export declare class EventTs {
}

export declare interface CustomLib {
    EventTs: {new (evevtTypeName: string, subscriber: (funcArg0: EventTs) => void, publisher: (funcArg0: EventTs) => void): EventTs}
    arktsFuncToCj(name: string, sub: (funcArg0: EventTs) => void, pub: (funcArg0: EventTs) => void): void
}