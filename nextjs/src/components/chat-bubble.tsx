import { Message } from '@/types'

interface ChatBubbleProps {
    message: Message
}

const ChatBubble = ({ message }: ChatBubbleProps) => {
    const isUser = message.role === 'user'

    return (
        <div className={`chat-bubble ${isUser ? 'user-bubble' : 'ai-bubble'}`}>
            <div className="font-bold mb-1">{isUser ? 'You' : 'Gemini'}</div>
            <div className="whitespace-pre-wrap">{message.content}</div>
        </div>
    )
}

export default ChatBubble