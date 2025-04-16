import { useState, FormEvent, KeyboardEvent } from 'react'

interface ChatInputProps {
    onSendMessage: (message: string) => void
    isLoading: boolean
}

const ChatInput = ({ onSendMessage, isLoading }: ChatInputProps) => {
    const [input, setInput] = useState('')

    const handleSubmit = (e: FormEvent) => {
        e.preventDefault()
        if (input.trim() && !isLoading) {
            onSendMessage(input)
            setInput('')
        }
    }

    const handleKeyDown = (e: KeyboardEvent<HTMLTextAreaElement>) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault()
            handleSubmit(e)
        }
    }

    return (
        <div className="chat-input-container">
            <form onSubmit={handleSubmit} className="flex gap-2">
                <textarea
                    className="flex-1 p-2 border border-gray-300 rounded-md resize-none focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Type your message..."
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    onKeyDown={handleKeyDown}
                    rows={2}
                    disabled={isLoading}
                />
                <button
                    type="submit"
                    className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-md disabled:bg-blue-300"
                    disabled={!input.trim() || isLoading}
                >
                    {isLoading ? 'Sending...' : 'Send'}
                </button>
            </form>
        </div>
    )
}

export default ChatInput