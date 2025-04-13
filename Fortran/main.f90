program gemini_chatbot
    implicit none
    character(len=1024) :: api_key, model, user_input, curl_command
    character(len=4096) :: json_payload, response
    integer :: status

    ! Load environment variables
    call get_environment_variable("GEMINI_API_KEY", api_key)
    call get_environment_variable("MODEL", model)

    ! Ask for user input
    print *, "Enter your message:"
    read(*,'(A)') user_input

    ! Construct JSON payload
    write(json_payload, '(A)') '{
        "contents": [{"role": "user", "parts": [{"text": "'//trim(user_input)//'"}]}]
    }'

    ! Construct cURL command
    write(curl_command, '(A)') 'curl -s -X POST https://generativelanguage.googleapis.com/v1beta/models/'// &
        trim(model)//':generateContent?key='//trim(api_key)// &
        ' -H "Content-Type: application/json" -d '''//trim(json_payload)//''''

    ! Run the cURL command and store response
    call execute_command_line(trim(curl_command), wait=.true., exitstat=status)

    if (status /= 0) then
        print *, "Error calling the Gemini API"
    else
        print *, "Request sent. Check response above."
    end if
end program gemini_chatbot
