const Messageable = () => {
    return class MessageableClass {
        protected message = 'hello';
    }
};
const wrapper = () => Messageable();
export type MP = InstanceType<ReturnType<typeof wrapper>>;
