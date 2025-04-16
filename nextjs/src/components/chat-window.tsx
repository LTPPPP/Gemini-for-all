import ChatBubble from './chat-bubble'
import { Message } from '@/types'

interface ChatWindowProps {
    messages: Message[]
}

const ChatWindow = ({ messages }: ChatWindowProps) => {
    if (messages.length === 0) {
        return (
            <div className="chat-window flex items-center justify-center text-gray-500">
                Start a conversation with Gemini AI
            </div>
        )
    }

    return (
        <div className="chat-window">
            {messages.map((message, index) => (
                <ChatBubble key={index} message={message} />
            ))}
        </div>
    )
}

export default ChatWindow