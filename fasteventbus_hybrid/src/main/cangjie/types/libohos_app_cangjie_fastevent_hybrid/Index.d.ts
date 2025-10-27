export declare class EventTs {
    constructor (evevtTypeName: string, subscriber: (funcArg0: EventTs) => void, publisher: (funcArg0: EventTs) => void)
}


export declare function register(name: string, sub: (funcArg0: EventTs) => void, pub: (funcArg0: EventTs) => void): void

export declare function unregister(eventTypeName: string): void

export declare function publish(eventTypeName: string): void

export declare function clearContainerByEventTypeName(eventTypeName: string): void
