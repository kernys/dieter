import { NextRequest, NextResponse } from 'next/server';
import { getUserFromRequest } from '@/lib/auth';
import { z } from 'zod';

const OPENROUTER_API_URL = 'https://openrouter.ai/api/v1/chat/completions';
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY!;

const chatSchema = z.object({
  message: z.string().min(1),
  locale: z.string().optional().default('en'),
  context: z.object({
    currentWeight: z.number().optional(),
    goalWeight: z.number().optional(),
    dailyCalorieGoal: z.number().optional(),
    todayCalories: z.number().optional(),
    streakDays: z.number().optional(),
  }).optional(),
});

function getLanguageInstruction(locale: string): string {
  const languageMap: Record<string, string> = {
    'ko': 'IMPORTANT: Respond in Korean (한국어) ONLY.',
    'ja': 'IMPORTANT: Respond in Japanese (日本語) ONLY.',
    'zh': 'IMPORTANT: Respond in Chinese (中文) ONLY.',
    'es': 'IMPORTANT: Respond in Spanish (Español) ONLY.',
    'fr': 'IMPORTANT: Respond in French (Français) ONLY.',
    'de': 'IMPORTANT: Respond in German (Deutsch) ONLY.',
  };

  return languageMap[locale] || '';
}

export async function POST(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const body = await request.json();
    const { message, locale, context } = chatSchema.parse(body);

    const languageInstruction = getLanguageInstruction(locale);

    const systemPrompt = `You are a friendly and supportive AI diet coach assistant named "Coach".
Your role is to help users achieve their health and fitness goals by providing:
- Personalized dietary advice
- Motivation and encouragement
- Answers to nutrition questions
- Tips for healthy eating habits
- Support for weight management

Keep your responses concise (2-3 sentences max for simple questions).
Be encouraging, positive, and supportive.
Use emojis occasionally to make the conversation friendly.

${languageInstruction}

${context ? `User Context:
- Current Weight: ${context.currentWeight || 'Not set'}
- Goal Weight: ${context.goalWeight || 'Not set'}
- Daily Calorie Goal: ${context.dailyCalorieGoal || 'Not set'}
- Today's Calories: ${context.todayCalories || 'Not tracked'}
- Current Streak: ${context.streakDays || 0} days` : ''}`;

    const response = await fetch(OPENROUTER_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
        'HTTP-Referer': 'https://diet-ai.app',
        'X-Title': 'Diet AI Coach',
      },
      body: JSON.stringify({
        model: 'google/gemini-2.5-flash',
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: message },
        ],
        max_tokens: 500,
        temperature: 0.7,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('Coach API error:', errorText);
      throw new Error('Failed to get response from AI');
    }

    const data = await response.json();
    const reply = data.choices?.[0]?.message?.content || 'Sorry, I could not generate a response.';

    return NextResponse.json({
      reply,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Coach error:', error);
    return NextResponse.json(
      { error: 'Failed to process request' },
      { status: 500 }
    );
  }
}
