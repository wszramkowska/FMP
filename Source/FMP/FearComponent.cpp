// Fill out your copyright notice in the Description page of Project Settings.


#include "FearComponent.h"
#include "TimerManager.h"
#include "GameFramework/Actor.h"

// Sets default values for this component's properties
UFearComponent::UFearComponent()
{

	PrimaryComponentTick.bCanEverTick = true;
	
}


// Called when the game starts
void UFearComponent::BeginPlay()
{
	Super::BeginPlay();

	// ...
	
}


// Called every frame
void UFearComponent::TickComponent(float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);
	
	UpdateFear(DeltaTime);
	
}

void UFearComponent::SetInDarkness(bool bDark)
{
	bIsInDarkness = bDark;
}

float UFearComponent::GetFearLevel() const
{
	return FearLevel;
}

void UFearComponent::UpdateFear(float DeltaTime)
{
	// Fear increase/decrease

	if (bIsInDarkness)
	{
		FearLevel += FearRiseRate * DeltaTime;
	}
	else
	{
		FearLevel -= FearFallRate * DeltaTime;
	}

	// Clamp
	FearLevel = FMath::Clamp(FearLevel, 0.0f, 1.0f);

	// Broadcast to Blueprints
	OnFearChanged.Broadcast(FearLevel);

	// Cry trigger

	if (FearLevel >= 0.95f && bCanCry)
	{
		HandleCry();
	}
}

void UFearComponent::HandleCry()
{
	bCanCry = false;

	// Reset fear after crying
	FearLevel = 0.5f;

	// Notify Blueprint for audio/animation and stuff
	OnCry.Broadcast();

	// Broadcast updated fear
	OnFearChanged.Broadcast(FearLevel);

	// Cooldown before next cry
	GetWorld()->GetTimerManager().SetTimer(
		CryCooldownTimer,
		[this]()
		{
			bCanCry = true;
		},
		3.0f,
		false
	);
}

