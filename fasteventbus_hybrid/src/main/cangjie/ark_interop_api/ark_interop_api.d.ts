export declare class EventTs {
}

export declare interface CustomLib {
    EventTs: {new (evevtTypeName: string, subscriber: (funcArg0: EventTs) => void, publisher: (funcArg0: EventTs) => void): EventTs}
    register(name: string, sub: (funcArg0: EventTs) => void, pub: (funcArg0: EventTs) => void): void
    unregister(eventTypeName: string): void
    unregisterAsync(eventTypeName: string): void
    publish(eventTypeName: string): void
    publishAsync(eventTypeName: string): void
    clearContainerByEventTypeName(eventTypeName: string): void
}